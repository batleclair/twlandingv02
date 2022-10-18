class RemoveEmployerNameFromCandidacies < ActiveRecord::Migration[7.0]
  def change
    remove_column :candidacies, :employer_name, :string
  end
end
