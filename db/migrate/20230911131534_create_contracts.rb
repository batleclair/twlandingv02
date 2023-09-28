class CreateContracts < ActiveRecord::Migration[7.0]
  def change
    create_table :contracts do |t|
      t.string :title
      t.references :contractable, polymorphic: true, null: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
