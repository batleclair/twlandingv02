class AddDescriptionToOfferLists < ActiveRecord::Migration[7.0]
  def change
    add_column :offer_lists, :description, :text
  end
end
