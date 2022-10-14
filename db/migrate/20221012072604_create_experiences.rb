class CreateExperiences < ActiveRecord::Migration[7.0]
  def change
    create_table :experiences do |t|
      t.string :employer
      t.string :title
      t.string :start_date
      t.string :end_year
      t.references :candidate, null: false, foreign_key: true

      t.timestamps
    end
  end
end
