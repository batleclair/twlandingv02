class AddStartYearToBeneficiaries < ActiveRecord::Migration[7.0]
  def change
    add_column :beneficiaries, :start_year, :integer
  end
end
