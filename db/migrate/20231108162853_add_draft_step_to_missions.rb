class AddDraftStepToMissions < ActiveRecord::Migration[7.0]
  def change
    add_column :missions, :draft_step, :integer, default: 0
  end
end
