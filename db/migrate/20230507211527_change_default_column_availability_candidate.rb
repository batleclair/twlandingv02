class ChangeDefaultColumnAvailabilityCandidate < ActiveRecord::Migration[7.0]
  def change
    change_column_default :candidates, :availability, nil
  end
end
