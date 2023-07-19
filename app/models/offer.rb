class Offer < ApplicationRecord
  belongs_to :beneficiary
  has_rich_text :summary
  has_rich_text :description
  has_many :candidacies
  has_many :candidates, through: :candidacies
  after_save :set_slug
  has_many :offer_bookmarks
  validates :beneficiary_id, presence: {message: "Il faut associer une asso à l'offre"}

  FUNCTIONS = [
    'IT/Data/Produit',
    'Finance/Gestion/Comptabilité',
    'Ressources Humaines',
    'Marketing/Communication',
    'Stratégie/Conseil',
    'Vente/Business Development',
    'Achats/Logistique',
    'Juridique',
    'Gestion de projet',
    'Qualité/Environnement'
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

  COMMITMENTS = [
    '👍 light',
    '👏 moyen',
    '🙌 costaud',
  ]

  REGIONS = [
    'Auvergne-Rhône-Alpes',
    'Bourgogne-Franche-Comté',
    'Bretagne',
    'Centre-Val de Loire',
    'Corse',
    'Grand Est',
    'Hauts-de-France',
    'Île-de-France',
    'Normandie',
    'Nouvelle-Aquitaine',
    'Occitanie',
    'Pays de la Loire',
    "Provence-Alpes-Côte d'Azur"
  ]

  def selected_by?(user)
    selection = Selection.find_by(offer: self, candidate: user.candidate)
    selection.present? && selection.liked? && selection.candidacy.nil? && selection.status.nil? ? true : false
  end

  def selection_by(user)
    selection = Selection.find_by(offer: self, candidate: user.candidate)
  end

  def active?
    status == 'active'
  end

  def public?
    publish && (status == 'active' || status == 'draft')
  end

  def frequency_output
    case
    when half_days_min.nil? && half_days_max.nil?
      return "à définir"
    when  (half_days_min.nil? && !half_days_max.nil?) || half_days_min == half_days_max
      return "#{half_days_max.fdiv(2).round(1).to_s.chomp('.0')} j / sem"
    when  (!half_days_min.nil? && half_days_max.nil?)
      return "#{half_days_min.fdiv(2).round(1).to_s.chomp('.0')} j / sem"
    else
      return "#{half_days_min.fdiv(2).round(1).to_s.chomp('.0')} à #{half_days_max.fdiv(2).round(1).to_s.chomp('.0')} j / sem"
    end
  end

  def duration_output
    case
    when months_min.nil? && months_max.nil?
      return "à définir"
    when  (months_min.nil? && !months_max.nil?) || months_min == months_max
      return "#{months_max} mois"
    when  (!months_min.nil? && months_max.nil?)
      return "#{months_min} mois"
    else
      return "#{months_min} à #{months_max} mois"
    end
  end

  def commitment_output
    if commitment.present?
      return commitment.insert(2, "Engagement ")
    else
      return "Engagement à définir"
    end
  end

  def set_slug
    self.slug = "#{beneficiary.name.parameterize}-#{title.parameterize}-#{id}"
  end

  def to_param
    slug
  end

  def structured_data(img_url)
    {
      '@context': "https://schema.org/",
      '@type': "JobPosting",
      title: title,
      description: description.to_plain_text.truncate(200),
      datePosted: created_at,
      employmentType: "Mecenat de competences",
      hiringOrganization: {
        '@type': "Organization",
        name: beneficiary.name,
        sameAs: beneficiary.web_url,
        logo: img_url
      },
      jobLocation: {
        '@type': "Place",
        address: {
          '@type': "PostalAddress",
          addressLocality: beneficiary.city,
          addressCountry: "France"
        }
      }
    }
  end
end
