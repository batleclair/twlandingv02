class CreateWhitelists < ActiveRecord::Migration[7.0]
  def change
    create_table :whitelists do |t|
      t.integer :input_type
      t.string :input_format
      t.string :custom_id
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
