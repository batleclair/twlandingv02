class AddTerminationColumnsToMissions < ActiveRecord::Migration[7.0]
  def change
    add_column :missions, :termination_cause, :integer
    add_column :missions, :termination_comment, :text
    add_column :missions, :time_confirmation, :boolean, default: false
    add_column :missions, :termination_confirmation, :boolean, default: false
  end
end
