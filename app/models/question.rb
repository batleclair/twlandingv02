class Question < ApplicationRecord
  belongs_to :company
  enum :input_type, {rating: 0, comment: 1, checkbox: 2}
end
