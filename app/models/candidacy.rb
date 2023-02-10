class Candidacy < ApplicationRecord
  belongs_to :candidate
  belongs_to :offer
  has_one :beneficiary, through: :offer
  validates :consent, acceptance: { message: "Veuillez accepter les conditions" }
end
