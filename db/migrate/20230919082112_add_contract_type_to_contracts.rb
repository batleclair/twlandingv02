class AddContractTypeToContracts < ActiveRecord::Migration[7.0]
  def change
    add_column :contracts, :contract_type, :integer
  end
end
