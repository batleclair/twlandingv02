class Whitelist < ApplicationRecord
  belongs_to :company
  enum :input_type, {email: 0, domain: 1}, suffix: true
  validates :input_format, uniqueness: { message: "Existe déjà"}
  validates :input_format, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "Adresse invalide" }, if: :email_input_type?
  validate :domain_presence, if: :email_input_type?

  def to_domain
    input_format.slice(/@.+/)&.delete("@") if email_input_type?
  end

  def domain_presence
    if company.whitelists.find_by(input_type: "domain", input_format: to_domain).nil?
      errors.add(:input_format, "Domaine non autorisé")
    end
  end

  def user_attached?
    User.where(company_id: self.company_id).find_by(email: self.input_format).present?
  end
end
