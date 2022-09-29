class AddFunctionToOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :function, :string
  end
end
