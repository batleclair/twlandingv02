class OfferRule < ApplicationRecord
  belongs_to :company
  enum :commitment, {"costaud": 0, "moyen": 1, "light": 2}
end
