class Offer < ApplicationRecord
  belongs_to :beneficiary
  has_rich_text :description
  has_many :candidacies
end
