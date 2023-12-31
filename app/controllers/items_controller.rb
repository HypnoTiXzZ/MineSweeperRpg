class ItemsController < ApplicationController
  def index
    @items = Item.where(user_id: 7).all #User 7 is the shop_account.
  end
end