class AddFormatToOfferRules < ActiveRecord::Migration[7.0]
  def change
    add_column :offer_rules, :half_days_max, :integer, default: 10
    add_column :offer_rules, :months_max, :integer, default: 24
  end
end
