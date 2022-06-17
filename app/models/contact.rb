class Contact < ApplicationRecord
  CONTACT_TYPES = ["Association", "Entreprise", "Salarié"]
  validates :contact_type, presence: true, inclusion: { in: CONTACT_TYPES }
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "merci de resenseigner une adresse valide" }
end
