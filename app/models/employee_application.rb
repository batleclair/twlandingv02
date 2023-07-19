class EmployeeApplication < ApplicationRecord
  belongs_to :user

  def pending?
    status.nil?
  end

  def rejected?
    status == "false"
  end

  def approved?
    status == "true"
  end

end
