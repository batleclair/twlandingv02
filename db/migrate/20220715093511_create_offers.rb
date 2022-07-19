class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.references :beneficiary, null: false, foreign_key: true
      t.string :title
      t.string :location
      t.integer :half_days_min
      t.integer :half_days_max
      t.integer :months_min
      t.integer :months_max
      t.integer :monthly_gross_salary

      t.timestamps
    end
  end
end
