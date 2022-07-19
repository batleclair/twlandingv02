class Beneficiary < ApplicationRecord
  has_many :offers
  has_one_attached :photo
  has_one_attached :logo
end
