class ChangeStatusTypeToIntegerInEmployeeApplications < ActiveRecord::Migration[7.0]
  def change
    remove_column :employee_applications, :status, :string
    add_column :employee_applications, :status, :integer
  end
end
