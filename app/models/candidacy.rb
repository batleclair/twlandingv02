class Candidacy < ApplicationRecord
  belongs_to :candidate
  belongs_to :offer
  validates :employer_name, presence: { message: "Veuillez renseigner votre employeur actuel" }, if: :employed?
  validates :consent, acceptance: { message: "Veuillez accepter les conditions" }
end
