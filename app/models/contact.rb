class Contact < ApplicationRecord
  CONTACT_BLACKLIST = [
    "ericjonesmyemail@gmail.com",
    "katytrilly9@gmail.com",
    "gloversteve282@gmail.com",
    "any.girl99@mail.ru"
  ]

  validates :first_name, presence: { message: "Veuillez renseigner votre prénom" }
  validates :last_name, presence: { message: "Veuillez renseigner votre nom" }
  validates :organization, presence: { message: "Merci d'indiquer votre entreprise ou association" }, unless: :candidate?
  validates :contact_type, presence: { message: "Veuillez sélectionner parmi les options" }
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "Veuillez renseigner une adresse valide" }
  validates :email, exclusion: { in: CONTACT_BLACKLIST, message: "🛑 vous avez été identifié·e comme spammer" }
  validates :phone_num, format: { with: /\A((\+33\s?\d)|(0\d))(\s|\.|\-)?\d{2}(\s|\.|\-)?\d{2}(\s|\.|\-)?\d{2}(\s|\.|\-)?\d{2}\z/, message: "Veuillez renseigner un n° français valide" }

  CONTACT_TYPES = ["Association", "Entreprise", "Salarié"]

  def candidate?
    contact_type == 'Candidat'
  end
end
