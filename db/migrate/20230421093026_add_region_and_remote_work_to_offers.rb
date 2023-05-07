class AddRegionAndRemoteWorkToOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :region, :string
    add_column :offers, :remote_work, :boolean, default: false
  end
end
