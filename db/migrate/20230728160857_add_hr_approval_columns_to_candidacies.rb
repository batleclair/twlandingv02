class AddHrApprovalColumnsToCandidacies < ActiveRecord::Migration[7.0]
  def change
    add_column :candidacies, :selection_status, :string
    add_column :candidacies, :application_status, :string
    add_column :candidacies, :airtable_id, :string
    add_column :candidacies, :req_start_date, :date
    add_column :candidacies, :req_days, :integer
    add_column :candidacies, :req_periodicity, :string
    add_column :candidacies, :req_periodicity_details, :string
    add_column :candidacies, :req_description, :text
    add_column :candidacies, :user_validation, :boolean
    add_column :candidacies, :user_validation_date, :date
    add_column :candidacies, :user_validation_message, :text
    add_column :candidacies, :manager_validation, :boolean
    add_column :candidacies, :admin_validation, :boolean
    add_column :candidacies, :admin_validation_date, :date
    add_column :candidacies, :admin_validation_message, :text
  end
end
