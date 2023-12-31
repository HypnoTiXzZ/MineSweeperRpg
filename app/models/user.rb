class User < ApplicationRecord
  has_one :map, dependent: :destroy
  has_many :items
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def claim_reward(amount)
    if balance.nil?
      self.balance = amount
    else
      self.balance += amount
    end
    save
  end
end
