class UsersController < ApplicationController
  def detail
    @user = User.find(params[:id])
    if @user == current_user
      render :detail
    else
      redirect_to :root_path
    end
  end

  def claim_reward
    @user = current_user
    puts '-------------------'
    puts @user.map_id.inspect
    puts '-------------------'
    @map = Map.find(@user.map_id)
    @map.destroy
    @user.claim_reward
    redirect_to user_home_path
  end

  def home
    if current_user.nil?
      redirect_to :root_path
    else
      @user = current_user
    end
  end
end
