class Candidate < ApplicationRecord
  include ControllerUtilities

  attr_accessor :should_validate
  attr_accessor :volunteering_aknowledged
  attr_accessor :admin_bypass_validation

  belongs_to :user
  has_many :candidacies, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_one_attached :cv
  has_one_attached :photo
  acts_as_taggable_on :skills

  validates :phone_num, format: { with: /\A((\+33\s?\d)|(0\d))(\s|\.|\-)?\d{2}(\s|\.|\-)?\d{2}(\s|\.|\-)?\d{2}(\s|\.|\-)?\d{2}\z/, message: "Veuillez renseigner un n° français valide" }, if: :not_admin?
  validates :status, presence: { message: "Sélectionnez parmi les options" }, if: :not_admin?
  validates :employer_name, presence: { message: "Renseignez l'employeur actuel" }, if: :employed?
  validates :description, presence: { message: "Présentez-vous en quelques mots" }, if: :should_validate?
  validates :function, inclusion: { in: Offer::FUNCTIONS, message: "Sélectionnez un domaine d'expertise" }, if: :should_validate?
  validates :location, presence: { message: "Indiquez votre ville de résidence" }, if: :should_validate?
  validates :primary_cause, length: { minimum: 2, message: "Sélectionnez au moins une catégorie" }, if: :should_validate?
  validates :availability, inclusion: {in: 1..3, message: "Sélectionnez au moins 1 jour / mois"}, if: :should_validate?
  # validates :volunteering_aknowledged, acceptance: { message: 'Veuillez cocher la case' }, if: -> { !employed? && should_validate? && !status.blank?}
  # validates :volunteering, presence: { message: "Avez-vous une expérience associative ?" }, if: :should_validate?
  # validate :skill_present, if: :should_validate?
  validate :basics
  validate :cv_file_type

  # after_create do
  #   clip_to_airtable
  #   save_to_airtable if first_completion?
  # end
  # after_update :save_to_airtable, if: :first_completion?

  FUNCTIONS = Offer::FUNCTIONS

  STATUSES = [
    "Salarié·e",
    "Freelance",
    "Autre"
  ]

  AVAILABILITY = [
    [1, "1 à 2 jours par mois"],
    [2, "1 jour par semaine"],
    [3, "+ d'1 jour par sem."]
  ]

  def employed?
    status == 'pt_employee' || status == 'ft_employee' || status == STATUSES[0]
  end

  def freelance?
    status == 'freelance' || status == STATUSES[1]
  end

  def min_info_present?
    if employed?
      phone_num.present? && status.present? && employer_name.present? && (linkedin_url.present? || cv.attached?)
    else
      phone_num.present? && status.present? && (linkedin_url.present? || cv.attached?)
    end
  end

  def info_missing?
    title.blank? || location.blank? || function.blank? || birth_date.blank?
  end

  def first_completion?
    profile_completed == false &&
    min_info_present? &&
    description.present? &&
    function.present? &&
    location.present? &&
    phone_num.present? &&
    availability > 0 &&
    # !skill_list.empty? &&
    # volunteering.present? &&
    primary_cause != [""]
  end

  def age
    birth_date.present? ? "#{(Date.current - birth_date).fdiv(365).floor} ans" : 'âge incconu'
  end

  def clean_linkedin_url
    linkedin_url.start_with?('http://') || linkedin_url.start_with?('https://') ? linkedin_url : "https://#{linkedin_url}"
  end

  def availability_output
    return AVAILABILITY[availability - 1][1]
  end

  def primary_causes
    a = []
    a << "Environnementale" if primary_cause.include?(Beneficiary::GOALS[0])
    a << "Sociale" if primary_cause.include?(Beneficiary::GOALS[1])
    return a
  end

  def not_admin?
    !admin_bypass_validation.present?
  end

  def clip_to_airtable
    @table = Airrecord.table(ENV["AIRTABLE_PAT"], ENV["AIRTABLE_CRM"], "Candidats")
    @record = @table.new(
      "Candidat": "#{user.first_name} #{user.last_name}",
      "Email": user.email,
      "Téléphone": phone_num,
      "Statut": status,
      "CV": Cloudinary::Utils.cloudinary_url(cv.key),
      "LinkedIn": linkedin_url,
      "Entreprise": employer_name,
      "Canal": ["Site web"]
      )
    @record.create
  end

  def save_to_airtable
    @table = Airrecord.table(ENV["AIRTABLE_PAT"], ENV["AIRTABLE_APP"], "Candidats")
    @record = @table.new(
      "Prénom": user.first_name,
      "Nom": user.last_name,
      "Email": user.email,
      "Phone": phone_num,
      "Statut": status,
      "Profil": description,
      "CV": Cloudinary::Utils.cloudinary_url(cv.key),
      "Linkedin": linkedin_url,
      "Localisation": location,
      "Entreprise": employer_name,
      "Compétences": [ function ],
      "Détails": skill_list.join(", "),
      "Bénévolat": volunteering,
      "Dispos": availability_output,
      "Dispo détails": availability_details,
      "Cause": primary_causes,
      "Télétravail": remote_work,
      "Remarques": comment,
      "Source": "Site",
      "Pas de rem": to_boolean(volunteering_aknowledged)
      )
    @record.create
  end

  private

  def should_validate?
    should_validate.present?
  end


  # def skill_present
  #   errors.add(:skill_list, "Indiquer au moins une compétence") if skill_list.empty?
  # end

  def basics
    return if !not_admin?
    pattern = /^((https?)(:\/\/))?(www.)?linkedin.[a-z]{2,3}\/in\/.+\/?$/
    if linkedin_url.blank? && !cv.attached?
      errors.add(:linkedin_url, "Renseignez a minima votre LinkedIn OU votre CV")
    elsif linkedin_url.present? && !linkedin_url.match?(pattern)
      errors.add(:linkedin_url, "Oh oh.. le lien indiqué semble erroné")
    end
  end

  def cv_file_type
    if cv.attached?
      errors.add(:linkedin_url, 'formats : PDF ou DOC') unless cv.content_type.in?(%w[application/pdf application/msword])
    end
  end
end
