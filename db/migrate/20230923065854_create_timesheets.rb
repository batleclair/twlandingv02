class CreateTimesheets < ActiveRecord::Migration[7.0]
  def change
    create_table :timesheets do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.text :comment
      t.references :mission, null: false, foreign_key: true

      t.timestamps
    end
  end
end
