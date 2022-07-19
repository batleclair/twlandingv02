class RemoveColumnsFromContacts < ActiveRecord::Migration[7.0]
  def change
    remove_column :contacts, :linkedin_url, :string
    remove_column :contacts, :phone_num, :string
  end
end
