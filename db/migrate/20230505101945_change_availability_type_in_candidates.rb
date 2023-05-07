class ChangeAvailabilityTypeInCandidates < ActiveRecord::Migration[7.0]
  def change
    remove_column :candidates, :availability
    add_column :candidates, :availability, :integer, default: 1
  end
end
