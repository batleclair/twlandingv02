class ChangeTypeNameInContacts < ActiveRecord::Migration[7.0]
  def change
    rename_column :contacts, :type, :contact_type
  end
end
