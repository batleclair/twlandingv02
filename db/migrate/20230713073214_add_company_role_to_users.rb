class AddCompanyRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :company_role, :string
  end
end
