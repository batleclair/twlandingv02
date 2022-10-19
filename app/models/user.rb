class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :candidate
  accepts_nested_attributes_for :candidate

  def admin?
    user_type == 'admin'
  end

  def applied?(offer)
    offer.candidates.where(user_id: id).none?
  end
end
