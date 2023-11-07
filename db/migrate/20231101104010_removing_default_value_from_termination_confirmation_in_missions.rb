class RemovingDefaultValueFromTerminationConfirmationInMissions < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:missions, :termination_confirmation, from: false, to: nil)
    change_column_default(:missions, :time_confirmation, from: false, to: nil)
  end
end
