class RenameRemoteWorkOfferesToFullRemote < ActiveRecord::Migration[7.0]
  def change
    rename_column :offers, :remote_work, :full_remote
  end
end
