class CreateSelections < ActiveRecord::Migration[7.0]
  def change
    create_table :selections do |t|
      t.references :offer, null: false, foreign_key: true
      t.references :candidate, null: false, foreign_key: true
      t.string :origin
      t.string :status
      t.text :response_msg

      t.timestamps
    end
  end
end
