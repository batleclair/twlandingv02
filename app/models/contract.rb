class Contract < ApplicationRecord
  belongs_to :contractable, polymorphic: true
  belongs_to :company
  has_one_attached :document

  enum :contract_type, {"convention de mécénat": 1, "avenant au contrat de travail": 2, "autre": 3}
end
