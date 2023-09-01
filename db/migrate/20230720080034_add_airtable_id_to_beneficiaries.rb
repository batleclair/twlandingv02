class AddAirtableIdToBeneficiaries < ActiveRecord::Migration[7.0]
  def change
    add_column :beneficiaries, :airtable_id, :string
  end
end
