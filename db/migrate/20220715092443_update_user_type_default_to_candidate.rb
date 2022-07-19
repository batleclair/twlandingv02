class UpdateUserTypeDefaultToCandidate < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :user_type, from: nil, to: 'candidate'
  end
end
