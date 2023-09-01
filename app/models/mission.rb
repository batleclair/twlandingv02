class Mission < ApplicationRecord
  belongs_to :candidacy
  has_one :offer, through: :candidacy

  def beneficiary
    offer.beneficiary
  end
end
