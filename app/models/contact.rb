class Contact < ApplicationRecord
  CONTACT_TYPES = ["Association", "Entreprise", "Salarié"]
  validates :first_name, presence: { message: "Veuillez renseigner votre prénom" }
  validates :last_name, presence: { message: "Veuillez renseigner votre nom" }
  validates :organization, presence: { message: "Merci d'indiquer votre entreprise ou association" }
  validates :contact_type, presence: { message: "Veuillez sélectionner parmi les options" }
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "Veuillez renseigner une adresse valide" }
end
