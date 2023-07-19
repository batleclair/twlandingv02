class AddSubdomainToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :slug, :string
  end
end
