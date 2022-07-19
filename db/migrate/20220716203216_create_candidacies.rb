class CreateCandidacies < ActiveRecord::Migration[7.0]
  def change
    create_table :candidacies do |t|
      t.references :candidate, null: false, foreign_key: true
      t.references :offer, null: false, foreign_key: true
      t.boolean :consent, default: false
      t.string :employer_name
      t.boolean :employer_aware
      t.integer :employer_ok_chance
      t.integer :half_days_wish
      t.date :start_date_wish
      t.text :motivation_msg

      t.timestamps
    end
  end
end
