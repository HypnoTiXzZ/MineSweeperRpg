class User < ApplicationRecord
  has_one :map, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def claim_reward
    if balance.nil?
      self.balance = 100
    else
      self.balance += 100
    end
    save
  end
end
