class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :candidate, autosave: true
  accepts_nested_attributes_for :candidate
  validates :first_name, presence: { message: "Woops ! Prénom requis" }
  validates :last_name, presence: { message: "Woops ! Nom requis" }
  after_create :send_welcome_mail

  def send_welcome_mail
    UserMailer.new_user_email(self).deliver
  end

  def admin?
    user_type == 'admin'
  end

  def applied?(offer)
    offer.candidates.where(user_id: id).none?
  end
end
