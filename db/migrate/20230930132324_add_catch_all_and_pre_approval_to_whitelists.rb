class AddCatchAllAndPreApprovalToWhitelists < ActiveRecord::Migration[7.0]
  def change
    add_column :whitelists, :catch_all, :boolean
    add_column :whitelists, :pre_approval, :boolean
  end
end
