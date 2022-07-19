class CreateCandidates < ActiveRecord::Migration[7.0]
  def change
    create_table :candidates do |t|
      t.string :linkedin_url
      t.string :phone_num
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
