class AddCustomInputToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :custom_input, :string
  end
end
