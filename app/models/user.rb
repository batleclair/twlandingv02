class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_one :candidate, autosave: true, dependent: :destroy
  has_many :employee_applications, through: :candidate, dependent: :destroy
  has_many :missions, through: :candidate, dependent: :destroy
  accepts_nested_attributes_for :candidate
  accepts_nested_attributes_for :employee_applications, reject_if: proc { |l| l[:status].blank? }
  validates :first_name, presence: { message: "Prénom requis" }
  validates :last_name, presence: { message: "Nom requis" }
  belongs_to :company, optional: true
  validate :not_blacklisted
  validate :company_whitelisted
  acts_as_token_authenticatable
  after_create :create_pre_approved_candidate, if: :pre_approved?

  enum :company_role, { user: "utilisateur", admin: "administrateur" }

  def send_welcome_mail
    UserMailer.new_user_email(self).deliver
  end

  def self.from_omniauth(auth, request)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.attach_company(request)
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.attach_custom_input if user.whitelisted?
      # raise
    end
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

  def pre_approved?
    company.whitelists.find_by(input_type: :email, input_format: email)&.pre_approval
  end

  def create_pre_approved_candidate
    candidate = Candidate.create(user_id: id)
    candidate.clip_to_airtable
    EmployeeApplication.create(candidate_id: candidate.id, status: "true", response_msg: "Eligibilité pré-validée par l'administrateur")
  end

  def eligibility
    never_applied? ? nil : last_employee_application.status
  end

  def not_eligible?
    last_employee_application&.revoked_status? || last_employee_application&.rejected_status?
  end

  def eligibility_on_going?
    last_employee_application.eligibility_on_going?
  end

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

  def attach_company(request)
    if Subdomain.new("tenant").matches?(request)
      self.company = Company.find_by(slug: request.subdomain)
      self.company_role = 'user'
    end
  end

  def company_whitelisted
    if company.present?
      errors.add(:email, "adresse non autorisée") if !whitelisted?
    end
  end

  def whitelist
    self.company.whitelists.find_by(input_type: :email, input_format: email)
  end

  def whitelisted?
      company.catch_all_domains.include?(email.slice(/@.+/)&.delete("@")) || (
        company.single_use_domains.include?(email.slice(/@.+/)&.delete("@")) &&
        whitelist.present?
      )
  end

  def attach_custom_input
    self.custom_input = self.company.whitelists.find_by(input_type: "email", input_format: self.email)&.input_custom
  end

  def not_blacklisted
    if first_name.include?('💳')
      errors.add(:general, "un problème est survenu, réessayez plus tard")
    end
  end

  def set_temp_password
    password = Devise.friendly_token
    self.password = password
    self.password_confirmation = password
  end

  def password_invite_token
    raw, enc = Devise.token_generator.generate(User, :reset_password_token)
    self.reset_password_token   = enc
    self.reset_password_sent_at = Time.now.utc + 30.days
    self.save(validate: false)
    raw
  end
end
