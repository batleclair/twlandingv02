class Selection < ApplicationRecord
  belongs_to :offer
  belongs_to :candidate

  validates :candidate_id, uniqueness: { scope: :offer_id }

  scope :suggested, -> { where.not(origin: "company_user") }
  scope :liked, -> { where(origin: "company_user") }
  scope :pending, -> { where(status: "").or(self.where(status: nil)) }
  scope :accepted, -> { where(status: "accepted") }
  scope :refused, -> { where(status: "refused") }


  def pending?
    status.blank?
  end

  def liked?
    origin == "company_user"
  end

  def applied?
    status == "accepted" && candidacy.present?
  end

  def refused?
    status == "refused"
  end

  def candidacy
    return Candidacy.find_by(offer_id: offer_id, candidate_id: candidate_id)
  end
end
