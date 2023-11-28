class AddPreFilledInfoToWhitelists < ActiveRecord::Migration[7.0]
  def change
    rename_column :whitelists, :input_custom, :custom_id
    rename_column :users, :custom_input, :custom_id
    add_column :whitelists, :first_name, :string
    add_column :whitelists, :last_name, :string
    add_column :whitelists, :title, :string
  end
end
