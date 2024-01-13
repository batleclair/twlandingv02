class EmployeeApplication < ApplicationRecord
  belongs_to :candidate
  has_one :user, through: :candidate
  has_one :company, through: :user
  validates :candidate_id, uniqueness: {scope: :status, message: "éligibilité active"}, if: :approved_status?
  validates :candidate_id, uniqueness: {scope: :status, message: "demande déjà en cours"}, if: :pending_status?
  validates :motivation_msg, length: { minimum: 10, message: "c'est un peu court 😶" }, on: :self_apply
  validates :response_msg, presence: { message: "un message est requis en cas de refus" }, if: :rejected_status?
  validates :status, presence: { message: "une réponse est requise" }
  enum :status, {pending: 0, approved: 1, rejected: 2, revoked: 3}, suffix: true
  belongs_to :eligibility_period, optional: true
  scope :status_as, -> (status) { status.nil? ? order(status: :asc, created_at: :desc) : where(status: status).order(status: :asc, created_at: :desc) }

  def eligibility_on_going?
    approved_status? && (eligibility_period.nil? || eligibility_period.start_date <= Date.today && eligibility_period.end_date > Date.today)
  end

  def last?
    EmployeeApplication.where(candidate_id: candidate_id).last == self
  end

  def self.clean_statuses
    {
      "A traîter": :pending,
      "Validées": :approved,
      "Refusées": :rejected,
      "Révoquées": :revoked
    }
  end

  def send_response_email
    Brevo::EmployeeApplicationMailer.send_response_email(self).deliver
  end
end
