class MapsController < ApplicationController
  def index
    @maps = Map.all
  end

  def show
    @map = Map.find(params[:id])
  end

  def new
    @map = Map.new
  end

  def destroy
    @map = Map.find(params[:id])
    @map.destroy

    redirect_to root_path, status: :see_other
  end

  def create_simple
    @map = Map.new(map_params)
    rows = 10 # Replace with the desired number of rows
    cols = 10 # Replace with the desired number of columns
    num_mines = 10 # Replace with the desired number of mines
    @map.generate_minesweeper_map(rows, cols, num_mines)
    if @map.save
      redirect_to @map, notice: 'Have Fun !'
    else
      render json: @map.errors, status: :unprocessable_entity
    end
  end

  def map_to_json
    @map = Map.find(params[:id])
    render json: @map
  end

  private

  def map_params
    params.require(:map).permit(:name)
  end
end
