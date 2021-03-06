class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :category
      t.string :organization
      t.string :linkedin_url
      t.string :phone_num
      t.text :message

      t.timestamps
    end
  end
end
