class AddRoleToWhitelists < ActiveRecord::Migration[7.0]
  def change
    add_column :whitelists, :role, :string, default: "utilisateur"
  end
end
