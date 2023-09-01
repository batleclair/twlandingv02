class AdjustStatusAndValidationColumnsInCandidacies < ActiveRecord::Migration[7.0]
  def change
    remove_column :candidacies, :admin_validation, :boolean
    rename_column :candidacies, :application_status, :last_active_status
    rename_column :candidacies, :selection_status, :origin
    rename_column :candidacies, :user_validation, :active
  end
end
