class AddWhitelistIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :whitelist, foreign_key: true
  end
end
