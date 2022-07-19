class Candidacy < ApplicationRecord
  belongs_to :candidate
  belongs_to :offer
end
