class AddQuestionnaireRelatedColumnsToCandidates < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :availability, :string
    add_column :candidates, :availability_details, :text
    add_column :candidates, :primary_cause, :text, array: true, default: []
    add_column :candidates, :secondary_cause, :text, array: true, default: []
    add_column :candidates, :remote_work, :boolean, default: false
    add_column :candidates, :comment, :text
  end
end
