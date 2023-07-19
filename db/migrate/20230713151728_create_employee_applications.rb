class CreateEmployeeApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_applications do |t|
      t.references :user, null: false, foreign_key: true
      t.text :motivation_msg
      t.string :status
      t.text :response_msg

      t.timestamps
    end
  end
end
