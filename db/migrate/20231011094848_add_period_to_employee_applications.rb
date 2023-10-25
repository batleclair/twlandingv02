class AddPeriodToEmployeeApplications < ActiveRecord::Migration[7.0]
  def change
    add_reference :employee_applications, :eligibility_period, null: true, foreign_key: true
  end
end
