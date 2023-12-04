class UsersController < ApplicationController
  def detail
    @user = User.find(params[:id])
    if @user == current_user
      render :detail
    else
      redirect_to :root_path
    end
  end
end
