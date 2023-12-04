class MapsController < ApplicationController
  def index
    @maps = Map.all
  end

  def show
    @map = Map.find(params[:id])
  end

  def map_to_json
    @map = Map.find(params[:id])
    render json: @map
  end
end
