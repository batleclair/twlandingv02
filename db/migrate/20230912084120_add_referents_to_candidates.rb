class AddReferentsToCandidates < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :referent_name, :string
    add_column :candidates, :referent_email, :string
  end
end
