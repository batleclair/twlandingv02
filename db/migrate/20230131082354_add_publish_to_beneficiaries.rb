class AddPublishToBeneficiaries < ActiveRecord::Migration[7.0]
  def change
    add_column :beneficiaries, :publish, :boolean, default: false
  end
end
