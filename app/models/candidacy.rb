class Candidacy < ApplicationRecord
  belongs_to :candidate
  belongs_to :offer
  has_one :beneficiary, through: :offer
  has_one :user, through: :candidate
  # validates :consent, acceptance: { message: "Veuillez accepter les conditions" }
  accepts_nested_attributes_for :candidate

  validates :candidate_id, uniqueness: { scope: :offer_id }

  def selection
    return Selection.find_by(offer_id: offer_id, candidate_id: candidate_id)
  end
end
