class AddTypeFeedbackInfoAndApprovalsToMissions < ActiveRecord::Migration[7.0]
  def change
    add_column :missions, :mission_type, :integer
    add_column :missions, :feedback_on, :boolean
    add_column :missions, :feedback_step, :integer
    add_column :missions, :feedback_unit, :integer
    add_column :missions, :feedback_start, :date
    add_column :missions, :beneficiary_approval, :integer, default: 0
    add_column :missions, :manager_approval, :integer, default: 0
  end
end
