class Candidacy < ApplicationRecord
  belongs_to :candidate
  belongs_to :offer
  validates :consent, acceptance: { message: "Veuillez accepter les conditions" }
end
