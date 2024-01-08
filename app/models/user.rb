class User < ApplicationRecord
  attr_accessor :demo
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_one :candidate, autosave: true, dependent: :destroy
  has_one :whitelist
  has_many :comment, dependent: :destroy
  has_many :employee_applications, through: :candidate, dependent: :destroy
  has_many :missions, through: :candidate, dependent: :destroy
  accepts_nested_attributes_for :candidate
  accepts_nested_attributes_for :employee_applications, reject_if: proc { |l| l[:status].blank? }
  validates :first_name, presence: { message: "Prénom requis" }
  validates :last_name, presence: { message: "Nom requis" }
  belongs_to :company, optional: true
  belongs_to :whitelist, optional: true
  validate :not_blacklisted
  validate :company_whitelisted
  acts_as_token_authenticatable
  after_create do
    (initialize_profile if whitelisted?) unless demo
    pre_approve if pre_approved?
  end

  enum :company_role, { user: "utilisateur", admin: "administrateur" }

  include PgSearch::Model
  pg_search_scope :search_by_name_and_email,
    against: [ :first_name, :last_name, :email ],
    using: {
      tsearch: { prefix: true }
    }

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
      # user.attach_custom_id if user.whitelisted?
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
    company ? company.slug : Subdomain.generic
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
    company&.whitelists&.find_by(input_type: :email, input_format: email)&.pre_approval
  end

  def pre_approve
    EmployeeApplication.create(candidate_id: candidate.id, status: :approved, response_msg: "Eligibilité pré-validée par l'entreprise")
    # candidate.clip_to_airtable
  end

  def eligibility
    never_applied? ? nil : last_employee_application.status
  end

  def not_eligible?
    last_employee_application&.revoked_status? || last_employee_application&.rejected_status?
  end

  def eligibility_on_going?
    last_employee_application&.eligibility_on_going?
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

  def candidacy_for(offer)
    candidate.candidacies&.find_by(offer: offer)
  end

  def active_candidacy?(offer)
    candidate.candidacies.find_by(offer: offer)&.active
  end

  def engaged?
    candidate.engaged?
  end

  def send_invite_email(password_invite_token)
    UserMailer.user_invite_email(self, password_invite_token).deliver
  end

  def attach_company(request)
    if Subdomain.new("tenant").matches?(request)
      self.company = Company.find_by(slug: request.subdomain)
      self.company_role = 'user'
    else
      company_domain = Whitelist.find_by(input_type: :domain, input_format: email.slice(/@.+/)&.delete("@"))
      self.company = company_domain&.company
      self.company_role = 'user' if company_domain
    end
  end

  def company_whitelisted
    if company.present?
      errors.add(:email, "adresse non autorisée") if !whitelisted?
    end
  end

  def find_whitelist
    Whitelist.find_by(input_type: :email, input_format: email)
  end

  def whitelisted?
    if company
      # company.catch_all_domains.include?(email.slice(/@.+/)&.delete("@")) || (
      #   company.single_use_domains.include?(email.slice(/@.+/)&.delete("@")) &&
      #   whitelist.present?
      # )
      company.catch_all_domains.include?(email.slice(/@.+/)&.delete("@")) || find_whitelist
    end
  end

  def initialize_profile
    Candidate.create(user_id: self.id, status: "Salarié·e", employer_name: self.company.name)
    if whitelist
      self.company_role = whitelist.role if whitelist.role
      self.first_name = whitelist.first_name if whitelist.first_name
      self.last_name = whitelist.last_name if whitelist.last_name
      self.custom_id = whitelist.custom_id
      self.whitelist = whitelist
      self.save
      candidate.update(title: whitelist.title)
      # raise
    end
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
