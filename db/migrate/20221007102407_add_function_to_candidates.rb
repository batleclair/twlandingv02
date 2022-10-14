class AddFunctionToCandidates < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :function, :string
  end
end
