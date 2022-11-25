class AddSlugToOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :slug, :string
  end
end
