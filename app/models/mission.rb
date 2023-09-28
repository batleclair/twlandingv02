class Mission < ApplicationRecord
  belongs_to :candidacy
  has_one :offer, through: :candidacy
  has_one :candidate, through: :candidacy
  has_many :contracts, as: :contractable, dependent: :destroy
  has_many :timesheets, dependent: :destroy
  validates :candidacy_id, uniqueness: { message: "Une mission a déjà été créée pour cette candidature" }
  accepts_nested_attributes_for :contracts, allow_destroy: true

  enum :mission_type, { "prestation de service": 0, "mise à disposition de personnel": 1 }
  enum :feedback_unit, { "jours": 0, "semaines": 1 }
  enum :manager_approval, {not_submitted: 0, submitted: 1, approved: 2, rejected: 3}, prefix: true
  enum :beneficiary_approval, {not_submitted: 0, submitted: 1, approved: 2, rejected: 3}, prefix: true


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
    last_active_status == "draft"
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
end
