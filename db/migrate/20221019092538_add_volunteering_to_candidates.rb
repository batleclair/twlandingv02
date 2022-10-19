class AddVolunteeringToCandidates < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :volunteering, :text
  end
end
