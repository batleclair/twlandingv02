class AddColumnToOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :publish, :boolean, default: false
  end
end
