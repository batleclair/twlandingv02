class CreateEligibilityPeriods < ActiveRecord::Migration[7.0]
  def change
    create_table :eligibility_periods do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.text :comment
      t.integer :status
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
