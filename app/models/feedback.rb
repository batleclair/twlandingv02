class Feedback < ApplicationRecord
  belongs_to :mission
  has_many :answers, dependent: :destroy
  has_one :candidate, through: :mission
  has_one :user, through: :candidate
  accepts_nested_attributes_for :answers
end
