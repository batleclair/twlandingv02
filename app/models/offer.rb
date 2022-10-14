class Offer < ApplicationRecord
  belongs_to :beneficiary
  has_rich_text :description
  has_many :candidacies
  has_many :candidates, through: :candidacies

  FUNCTIONS = [
    'IT/Data/Produit',
    'Finance/Gestion/Comptabilité',
    'Ressources Humaines',
    'Marketing/Communication',
    'Stratégie/Conseil',
    'Ventes/Business Development',
    'Achats/Logistique',
    'Administration',
    'Juridique',
    'Qualité/Environement'
  ]

  OFFER_TYPES = [
    'Mécénat/Temps partagé',
    'Freelance',
    'Co-recrutement'
  ]

  STATUSES = [
    'active',
    'upcoming',
    'old',
    'draft'
  ]

  def active?
    status == 'active'
  end

  def new?
    status == 'new'
  end
end
