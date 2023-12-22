class AddInfoSrcToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :user_info_source, :string
    add_column :companies, :admin_info_source, :string
  end
end
