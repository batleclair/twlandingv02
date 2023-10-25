class ChangeStatusToIntegerInCandidacies < ActiveRecord::Migration[7.0]
  def change
    remove_column :candidacies, :last_active_status, :string
    add_column :candidacies, :status, :integer, default: 0
  end
end
