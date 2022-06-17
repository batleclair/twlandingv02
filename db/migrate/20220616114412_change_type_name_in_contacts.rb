class ChangeTypeNameInContacts < ActiveRecord::Migration[7.0]
  def change
    rename_column :contacts, :category, :contact_type
  end
end
