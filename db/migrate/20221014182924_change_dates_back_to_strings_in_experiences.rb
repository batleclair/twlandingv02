class ChangeDatesBackToStringsInExperiences < ActiveRecord::Migration[7.0]
  change_table :experiences do |t|
    t.change :start_date, :string
    t.change :end_date, :string
  end
end
