class AddSlugToBeneficiaries < ActiveRecord::Migration[7.0]
  def change
    add_column :beneficiaries, :slug, :string
  end
end
