class CreateOfferLists < ActiveRecord::Migration[7.0]
  def change
    create_table :offer_lists do |t|
      t.string :title
      t.string :slug

      t.timestamps
    end
  end
end
