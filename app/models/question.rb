class Question < ApplicationRecord
  belongs_to :company
  enum :input_type, {integer: 0, text: 1, boolean: 2}
end
