class ChangeTypeNameInOffers < ActiveRecord::Migration[7.0]
  def change
    rename_column :offers, :type, :offer_type
  end
end
