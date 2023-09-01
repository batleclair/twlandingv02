class AddAirtableIdColumToOffersAndCandidates < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :airtable_id, :string
    add_column :offers, :airtable_id, :string
  end
end
