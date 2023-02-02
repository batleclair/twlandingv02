class OfferList < ApplicationRecord
  has_many :offer_bookmarks, dependent: :destroy
  has_many :offers, through: :offer_bookmarks
end
