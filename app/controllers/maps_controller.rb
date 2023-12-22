class MapsController < ApplicationController
  def index
    @maps = Map.all
    if current_user
      redirect_to user_home_path
    end
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

    redirect_to root_path
  end

  def create_simple
    difficulty = params.dig(:map, :difficulty)
    puts 'hahaha' + difficulty.inspect
    case difficulty
    when 'easy'
      rows, cols, num_mines = 9, 9, 10
    when 'medium'
      rows, cols, num_mines = 16, 16, 40
    when 'hard'
      rows, cols, num_mines = 30, 16, 99
    when 'extreme'
      rows, cols, num_mines = 30, 24, 160
    else
      rows, cols, num_mines = 9, 9, 10
    end
    @map = Map.new(map_params)
    @map.generate_minesweeper_map(rows, cols, num_mines)
    if @map.save
      current_user.update(map_id: @map.id)
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
