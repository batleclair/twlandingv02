class CreateBeneficiaries < ActiveRecord::Migration[7.0]
  def change
    create_table :beneficiaries do |t|
      t.string :name
      t.string :cause
      t.string :address
      t.string :city
      t.string :siren
      t.string :rna

      t.timestamps
    end
  end
end
