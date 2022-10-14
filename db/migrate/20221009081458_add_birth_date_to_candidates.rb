class AddBirthDateToCandidates < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :birth_date, :date
  end
end
