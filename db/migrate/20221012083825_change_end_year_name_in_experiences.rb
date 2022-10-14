class ChangeEndYearNameInExperiences < ActiveRecord::Migration[7.0]
  def change
    rename_column :experiences, :end_year, :end_date
  end
end
