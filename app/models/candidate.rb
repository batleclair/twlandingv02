class Candidate < ApplicationRecord
  belongs_to :user
  has_many :candidacies, dependent: :destroy
  has_one_attached :cv
end
