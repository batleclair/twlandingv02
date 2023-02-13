class AddPhoneNumberToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :phone_num, :string
  end
end
