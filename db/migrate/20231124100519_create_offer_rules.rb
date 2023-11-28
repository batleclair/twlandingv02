class CreateOfferRules < ActiveRecord::Migration[7.0]
  def change
    create_table :offer_rules do |t|
      t.integer :commitment, default: 0
      t.boolean :full_remote
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
