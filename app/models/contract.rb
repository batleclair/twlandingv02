class Contract < ApplicationRecord
  belongs_to :contractable, polymorphic: true
  belongs_to :company

  enum :contract_type, {"convention de mécénat": 1, "avenant au contrat de travail": 2, "autre": 3}
end
