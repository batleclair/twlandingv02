class Timesheet < ApplicationRecord
  belongs_to :mission
  has_one :candidacy, through: :mission
  has_one :candidate, through: :candidacy
  has_one :user, through: :candidate
  has_one :company, through: :user

  def reported_hours
    (end_time - start_time).fdiv(3600).ceil.to_i
  end
end
