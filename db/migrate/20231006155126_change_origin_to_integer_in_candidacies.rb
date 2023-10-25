class ChangeOriginToIntegerInCandidacies < ActiveRecord::Migration[7.0]
  def change
    remove_column :candidacies, :origin, :string
    add_column :candidacies, :origin, :integer
  end
end
