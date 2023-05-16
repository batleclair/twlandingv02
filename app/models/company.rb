class Company < ApplicationRecord
  validates :name, uniqueness: { message: "Ce nom d'entreprise existe déjà" }
  has_many :users
end
