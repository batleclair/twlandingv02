class CreateMissions < ActiveRecord::Migration[7.0]
  def change
    create_table :missions do |t|
      t.references :candidacy, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :periodicity
      t.integer :days_count
      t.string :title
      t.text :description
      t.string :referent_name
      t.string :referent_email
      t.boolean :active
      t.string :last_active_status

      t.timestamps
    end
  end
end
