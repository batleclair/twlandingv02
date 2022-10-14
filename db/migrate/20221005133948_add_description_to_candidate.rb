class AddDescriptionToCandidate < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :description, :text
  end
end
