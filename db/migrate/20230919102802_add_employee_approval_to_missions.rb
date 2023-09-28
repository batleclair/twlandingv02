class AddEmployeeApprovalToMissions < ActiveRecord::Migration[7.0]
  def change
    add_column :missions, :employee_approval, :boolean
  end
end
