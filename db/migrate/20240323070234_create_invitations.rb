class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :linkedin_url
      t.string :phone_num
      t.string :location
      t.string :status
      t.string :employer_name
      t.string :title
      t.text :description
      t.string :function
      t.integer :availability
      t.text :volunteering
      t.text :comment
      t.boolean :profile_completed, default: false
      t.string :airtable_id

      t.timestamps
    end
  end
end
