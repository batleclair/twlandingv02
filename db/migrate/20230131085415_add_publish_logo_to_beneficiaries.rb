class AddPublishLogoToBeneficiaries < ActiveRecord::Migration[7.0]
  def change
    add_column :beneficiaries, :publish_logo, :boolean, default: false
  end
end
