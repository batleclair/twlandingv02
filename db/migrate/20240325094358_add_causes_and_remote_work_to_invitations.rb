class AddCausesAndRemoteWorkToInvitations < ActiveRecord::Migration[7.0]
  def change
    add_column :invitations, :primary_cause, :text, array: true, default: []
    add_column :invitations, :skill_list, :text, array: true, default: []
    add_column :invitations, :remote_work, :boolean, default: false
    add_column :invitations, :availability_details, :text
  end
end
