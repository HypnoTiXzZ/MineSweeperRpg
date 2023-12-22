class UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def detail
    @user = User.find(params[:id])
    if @user == current_user
      render :detail
    else
      redirect_to :root_path
    end
  end

  def give_reward()
    @user = current_user
    data = JSON.parse(request.body.read)
    won = data['won']
    if won == true
      @user.claim_reward(data['reward_amount'])
      render json: { message: 'Récompense attribuée avec succes' }
    else
      render json: { message: 'you did not win' }
    end
  end

  def claim_reward
    @user = current_user
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
