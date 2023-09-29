class AddInputsToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :boolean_answer, :boolean
    add_column :answers, :integer_answer, :integer
    add_column :answers, :text_answer, :text
  end
end
