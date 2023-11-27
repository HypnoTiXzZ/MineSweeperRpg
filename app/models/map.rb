class Map < ApplicationRecord
  
  def generate_minesweeper_map(rows, cols, num_mines)
    tiles = Array.new(rows) { Array.new(cols, 0) }
    mines = Set.new

    while mines.size < num_mines
      row = rand(rows)
      col = rand(cols)
      mines.add([row, col])
      tiles[row][col] = -1
    end

    mines.each do |mine|
      row, col = mine

      (-1..1).each do |dx|
        (-1..1).each do |dy|
          next if dx == 0 && dy == 0

          nx = row + dx
          ny = col + dy

          next if nx < 0 || nx >= rows || ny < 0 || ny >= cols
          next if tiles[nx][ny] == -1

          tiles[nx][ny] += 1
        end
      end
    end

    self.tiles = tiles
    save
  end
end
