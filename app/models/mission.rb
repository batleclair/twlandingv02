class Mission < ApplicationRecord
  belongs_to :candidacy
  has_one :offer, through: :candidacy
  has_one :candidate, through: :candidacy
  has_one :beneficiary, through: :candidacy
  has_one :feedback, dependent: :destroy
  has_many :contracts, as: :contractable, dependent: :destroy
  has_many :timesheets, dependent: :destroy
  validates :end_date, comparison: { greater_than: :start_date, message: "Doit être supérieure à la date de début" }
  validates :candidacy_id, uniqueness: { message: "Une mission a déjà été créée pour cette candidature" }
  validates :termination_confirmation, acceptance: { message: "Confirmation requise"}, if: :terminated_status?
  validates :time_confirmation, acceptance: { message: "Confirmation requise"}, allow_nil: true
  accepts_nested_attributes_for :contracts, allow_destroy: true

  enum :status, { draft: 0, abandonned: 1, activated: 2, terminated: 3 }, suffix: true
  enum :mission_type, { "prestation de service": 0, "mise à disposition de personnel": 1 }
  enum :feedback_unit, { "jours": 0, "semaines": 1 }
  enum :manager_approval, {not_submitted: 0, submitted: 1, approved: 2, rejected: 3}, prefix: true
  enum :beneficiary_approval, {not_submitted: 0, submitted: 1, approved: 2, rejected: 3}, prefix: true
  enum :termination_cause, {"la mission touche à sa fin": 0, "la mission ne se passe pas comme prévu": 1}, prefix: true

  after_update :deactivate_candidacy, if: :terminated_status?


  def feedback_info_valid?
    !feedback_on || (
      feedback_on &&
      feedback_unit.present? &&
      feedback_step.present? &&
      feedback_start.present?
    )
  end

  def info_completed?
    feedback_info_valid? &&
    start_date.present? &&
    end_date.present? &&
    periodicity.present? &&
    days_count.present? &&
    title.present? &&
    description.present?
  end

  def sendable_to_beneficiary?
    info_completed? && manager_approval_approved? && beneficiary_approval_not_submitted?
  end

  def no_doc_upload?(enum)
    contracts.where(contract_type: enum).empty?
  end

  def employee_based?
    Mission.mission_types[self.mission_type] == 1
  end

  def ready_to_go?
    info_completed? &&
    manager_approval_approved? &&
    beneficiary_approval_approved? &&
    (employee_approval if employee_based?)
  end

  def draft?
    status == "draft"
  end

  def total_hours
    i = 0
    timesheets.each do |timesheet|
      i+= timesheet.reported_hours
    end
    return i
  end

  def total_days
    timesheets.count
  end

  def deactivate_candidacy
    candidacy.update(active: false)
  end

  def new_contract?
    !contracts.empty? && contracts.last.id.nil?
  end
end
