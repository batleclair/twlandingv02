class Answer < ApplicationRecord
  belongs_to :feedback
  belongs_to :question
end
