class CreateOfferBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :offer_bookmarks do |t|
      t.references :offer, null: false, foreign_key: true
      t.references :offer_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
