class AddCallStatusToCandidates < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :call_status, :integer, default: 0
  end
end
