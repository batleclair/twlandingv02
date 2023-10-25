class ChangeUserIdToCandidateIdInEmployeeApplications < ActiveRecord::Migration[7.0]
  def change
    remove_reference :employee_applications, :user, null: false, foreign_key: true
    add_reference :employee_applications, :candidate, null: false, foreign_key: true
  end
end
