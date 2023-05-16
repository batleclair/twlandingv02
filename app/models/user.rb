class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :candidate, autosave: true, dependent: :destroy
  accepts_nested_attributes_for :candidate
  validates :first_name, presence: { message: "Prénom requis" }
  validates :last_name, presence: { message: "Nom requis" }
  has_one :company

  def send_welcome_mail
    UserMailer.new_user_email(self).deliver
  end

  def admin?
    user_type == 'admin'
  end

  def applied?(offer)
    offer.candidates.where(user_id: id).none?
  end

  def send_invite_email(password_invite_token)
    UserMailer.user_invite_email(self, password_invite_token).deliver
  end
end
