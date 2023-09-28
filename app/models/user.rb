class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :candidate, autosave: true, dependent: :destroy
  has_many :employee_applications, dependent: :destroy
  accepts_nested_attributes_for :candidate
  accepts_nested_attributes_for :employee_applications, reject_if: proc { |l| l[:status].blank? }
  validates :first_name, presence: { message: "Prénom requis" }
  validates :last_name, presence: { message: "Nom requis" }
  belongs_to :company, optional: true
  validate :not_blacklisted
  acts_as_token_authenticatable

  enum :company_role, { user: "utilisateur", admin: "administrateur" }

  def send_welcome_mail
    UserMailer.new_user_email(self).deliver
  end

  def admin?
    user_type == 'admin'
  end

  def company_admin?
    company_role == 'admin'
  end

  def company_user?
    company_role == 'user'
  end

  def role
    case
    when admin?
      "admin"
    when company_admin?
      "company_admin"
    when company_user?
      "company_user"
    else
      "user"
    end
  end

  def subdomain
    company&.slug
  end

  def never_applied?
    employee_applications.empty?
  end

  def last_employee_application
    employee_applications.last
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name.first}#{last_name.first}"
  end

  # def approved?
  #   employee_applications.where(status: "true").any?
  # end

  # def pending?
  #   employee_applications.where(status: nil).any?
  # end

  # def rejected?
  #   employee_applications.any? && !self.pending? && !self.approved? && !self.never_applied?
  # end

  def applied?(offer)
    offer.candidates.where(user_id: id).none?
  end

  def send_invite_email(password_invite_token)
    UserMailer.user_invite_email(self, password_invite_token).deliver
  end

  def not_blacklisted
    if first_name.include?('💳')
      errors.add(:general, "un problème est survenu, réessayez plus tard")
    end
  end
end
