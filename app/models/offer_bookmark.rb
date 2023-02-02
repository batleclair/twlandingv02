class OfferBookmark < ApplicationRecord
  belongs_to :offer
  belongs_to :offer_list
  validates_uniqueness_of :offer_list_id, scope: :offer_id, message: "cette mission figure déjà dans la liste"
end
