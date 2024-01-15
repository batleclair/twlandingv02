class Whitelist < ApplicationRecord
  attr_accessor :batch_file
  attr_accessor :has_headers

  belongs_to :company
  enum :input_type, {email: 0, domain: 1}, suffix: true
  validates :input_format, uniqueness: { message: "Adresse déjà utilisée"}, if: :email_input_type?
  validates :input_format, uniqueness: { message: "Domaine déjà utilisé"}, if: :domain_input_type?
  validates :input_format, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "Adresse invalide" }, if: :email_input_type?
  validates :first_name, presence: { message: "Prénom requis" }, if: :email_input_type?
  validate :domain_presence, if: :email_input_type?
  validate :no_user_attached?, on: :create
  enum :role, { user: "utilisateur", admin: "administrateur" }, suffix: true
  has_one :user, dependent: :nullify
  before_commit :send_invite_email, on: :create, if: :email_input_type?

  include PgSearch::Model
  pg_search_scope :search_by_name_and_email,
    against: [ :first_name, :last_name, :input_format ],
    using: {
      tsearch: { prefix: true }
    }

  def to_domain
    # input_format.slice(/@.+/)&.delete("@") if email_input_type?
    input_format.slice(/@.+/)&.delete("@")
  end

  def domain_presence
    unless company.whitelists.find_by(input_type: :domain, input_format: to_domain)
      errors.add(:input_format, "Domaine non autorisé")
    end
  end

  def user_attached?
    User.where(company_id: self.company_id).find_by(email: self.input_format).present?
  end

  def no_user_attached?
    errors.add(:input_format, "Cette adresse est déjà utilisée") if (user_attached? && email_input_type?)
  end

  def email
    input_format
  end

  def user
    User.find_by(company_id: company_id, email: input_format)
  end

  def send_invite_email
    Brevo::WhitelistMailer.invitation_email_for(self).deliver
  end
end
