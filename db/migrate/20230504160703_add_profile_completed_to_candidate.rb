class AddProfileCompletedToCandidate < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :profile_completed, :boolean, default: false
  end
end
