class Beneficiary < ApplicationRecord
  has_many :offers, dependent: :destroy
  has_many :candidacies, through: :offers
  has_one_attached :photo
  has_one_attached :profile_pic_one
  has_one_attached :profile_pic_two
  has_one_attached :profile_pic_three
  has_one_attached :logo
  validate :basics
  validates :name, uniqueness: true
  validate :logo_file_type
  has_rich_text :description
  has_rich_text :long_desc
  after_save :set_slug

  GOALS = [
    'Environnement',
    'Social'
  ]

  CAUSES = [
    "Aide humanitaire",
    "Hébergement d'urgence",
    "Aide alimentaire",
    "Education & égalité des chances",
    "(Ré)insertion professionnelle",
    "Protection des personnes",
    "Protection du vivant",
    "Protection de l'environnement",
    "Handicaps & maladies",
    "Lien social",
    "Art, culture & patrimoine",
    "Egalité & citoyenneté"
  ]

  def set_slug
    self.slug = name.parameterize
  end

  def to_param
    slug
  end

  def home_url(beneficiary_path)
    if publish
      beneficiary_path
    elsif web_url.present?
      web_url
    else
      ""
    end
  end

  private

  def basics
    if name.blank? && !logo.attached?
      errors.add(:basics, "super cool")
    end
  end

  def logo_file_type
    if logo.attached?
      errors.add(:logo, 'formats : jpeg, png ou gif') unless logo.content_type.in?(%w[image/jpeg image/png image/gif])
    end
  end
end
