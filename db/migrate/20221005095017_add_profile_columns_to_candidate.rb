class AddProfileColumnsToCandidate < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :title, :string
    add_column :candidates, :location, :string
    add_column :candidates, :employer_name, :string
    add_column :candidates, :employer_approved, :boolean, default: false
  end
end
