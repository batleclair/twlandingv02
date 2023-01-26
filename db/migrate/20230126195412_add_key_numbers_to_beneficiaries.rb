class AddKeyNumbersToBeneficiaries < ActiveRecord::Migration[7.0]
  def change
    add_column :beneficiaries, :kpi_one, :string
    add_column :beneficiaries, :kpt_one, :string
    add_column :beneficiaries, :kpi_two, :string
    add_column :beneficiaries, :kpt_two, :string
    add_column :beneficiaries, :kpi_three, :string
    add_column :beneficiaries, :kpt_three, :string
  end
end
