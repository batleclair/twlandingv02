class AddLinksToBeneficiaries < ActiveRecord::Migration[7.0]
  def change
    add_column :beneficiaries, :web_url, :string
    add_column :beneficiaries, :li_url, :string
  end
end
