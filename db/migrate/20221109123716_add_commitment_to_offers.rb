class AddCommitmentToOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :commitment, :string
  end
end
