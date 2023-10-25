class ChangeStatusToIntegerInMissions < ActiveRecord::Migration[7.0]
  def change
    remove_column :missions, :last_active_status, :string
    add_column :missions, :status, :integer, default: 0
  end
end
