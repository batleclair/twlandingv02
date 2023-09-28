class Company < ApplicationRecord
  validates :name, uniqueness: { message: "Ce nom d'entreprise existe déjà" }
  has_many :users
  has_many :contracts
  has_one_attached :logo
end
