class RenameCustomIdColumnInWhitelists < ActiveRecord::Migration[7.0]
  def change
    rename_column :whitelists, :custom_id, :custom_id
  end
end
