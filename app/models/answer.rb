class Answer < ApplicationRecord
  belongs_to :feedback
  belongs_to :question
  validates :integer_answer, numericality: {in: 1..5, message: "Note de 1 à 5"}, allow_nil: true
end
