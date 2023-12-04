import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["data", "mapDiv"]
  connect() {
    this.directions = [
      { dx: -1, dy: 0 }, // left
      { dx: -1, dy: -1 }, // up-left
      { dx: -1, dy: 1 }, // down-left
      { dx: 1, dy: 0 },  // right
      { dx: 1, dy: -1 },  // up-right
      { dx: 1, dy: 1 },  // down-right
      { dx: 0, dy: -1 }, // up
      { dx: 0, dy: 1 }   // down
    ];

    const url = window.location.href;
    const id = url.split('/').pop();
    fetch('/maps/' + id + '/map_to_json')
    .then(response => response.json())
    .then(data => {
      this.gameOver = false;
      this.minesweeperMap = data.tiles;
      // `data` will contain the map object as a JavaScript object
      this.generateMinesweeperMap(data.tiles.length, data.tiles[0].length);
      // Use the map data to render it on your front-end
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }

  generateMinesweeperMap(x, y) {
    if (this.minesweeperMap === null) 
      return
    const mapDiv = this.mapDivTarget;
  
    for (let row = 0; row < y; row++) {
      const lineDiv = document.createElement("div");
      lineDiv.className = "line";
  
      for (let col = 0; col < x; col++) {
        const tileDiv = document.createElement("div");
        tileDiv.id = `cell_${col}_${row}`;
        tileDiv.className = "cell_closed size24 cell";
        tileDiv.setAttribute("data-x", col);
        tileDiv.setAttribute("data-y", row);
        this.assign_tile(tileDiv);
        lineDiv.appendChild(tileDiv);
      }
  
      mapDiv.appendChild(lineDiv);
    }
  }

  assign_tile(tileDiv) {
    tileDiv.addEventListener('click', () => {
      this.revealTile(tileDiv, tileDiv.getAttribute("data-x"), tileDiv.getAttribute("data-y"));
      this.revealTilesAround(tileDiv.getAttribute("data-x"), tileDiv.getAttribute("data-y"));
    })

    tileDiv.addEventListener('contextmenu', (event) => {
      event.preventDefault();
      this.toggleFlagTile(tileDiv)
    });
  }
  revealTile(tile, x, y) {
    if (this.gameOver === true)
      return;
    if (this.isTileFlaged(x, y)) {
      return;
    }
    const tileValue = this.minesweeperMap[x][y];
    if (tileValue === -1) {
      this.triggerMineRed(tile)
    } else if (tileValue === 0) {
      this.trigger(tile, 'cell-' + tileValue);
      this.revealAdjacentTiles(x, y);
    } else {
      this.trigger(tile, 'cell-' + tileValue);
    }
  }

  revealTilesAround(x, y) {
    if (this.isTileClosed(x, y))
      return;
    if (this.getFlaggedTilesAround(x, y).length === this.minesweeperMap[x][y]) {
      for (const direction of this.directions) {
        const newX = parseInt(x) + parseInt(direction.dx);
        const newY = parseInt(y) + parseInt(direction.dy);
        if (this.isValidTile(newX, newY) && this.isTileClosed(newX, newY) && !this.isTileFlaged(newX, newY)) {
          console.log(newX, newY, !this.isTileFlaged(newX, newY))
          const tileDiv = this.getTileDiv(newX, newY);
          this.revealTile(tileDiv, newX, newY);
        }
      }
    }
  }

  revealAdjacentTiles(x, y) {
    for (const direction of this.directions) {
      const newX = parseInt(x) + parseInt(direction.dx);
      const newY = parseInt(y) + parseInt(direction.dy);

      if (this.isValidTile(newX, newY) && this.isTileClosed(newX, newY)) {
        const tileDiv = this.getTileDiv(newX, newY);
        this.revealTile(tileDiv, newX, newY);
      }
    }
  }

  getFlaggedTilesAround(x, y) {
    const flaggedTiles = [];
    for (const direction of this.directions) {
      const newX = parseInt(x) + parseInt(direction.dx);
      const newY = parseInt(y) + parseInt(direction.dy);
      if (this.isValidTile(newX, newY)) {
        const tileDiv = this.getTileDiv(newX, newY);
        if (tileDiv.classList.contains('cell-flaged')) {
          flaggedTiles.push(tileDiv);
        }
      }
    }
    return flaggedTiles;
  }


  isValidTile(x, y) {
    return x >= 0 && x < this.minesweeperMap.length && y >= 0 && y < this.minesweeperMap[0].length;
  }
  
  isTileFlaged(x, y) {
    const tileDiv = this.getTileDiv(x, y);
    return tileDiv.classList.contains('cell-flaged');
  }
  isTileClosed(x, y) {
    const tileDiv = this.getTileDiv(x, y);
    return tileDiv.classList.contains('cell_closed');
  }

  toggleFlagTile(tile) {
    if (this.gameOver === true)
      return;
    if (tile.classList.contains('cell-flaged')) {
      tile.classList.remove('cell-flaged');
    }
    else {
      tile.classList.add('cell-flaged');
    }
  }

  trigger(tile, cellType) {
    if (!tile.classList.contains('cell-flaged')) {
      tile.classList.add(cellType);
      tile.classList.remove('cell_closed');
    }
  }

  triggerMineRed(tile) {
    this.gameOver = true;
    tile.classList.add('cell_red_mine');
    tile.classList.remove('cell_closed');
  }

  getTileDiv(x, y) {
    const selector = `[data-x="${x}"][data-y="${y}"]`;
    const tileDiv = document.querySelector(selector);
    return tileDiv;
  }
}