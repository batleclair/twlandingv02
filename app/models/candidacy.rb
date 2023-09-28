class Candidacy < ApplicationRecord
  belongs_to :candidate
  belongs_to :offer
  has_one :beneficiary, through: :offer
  has_one :mission
  has_one :user, through: :candidate
  has_many :comments, as: :commentable, dependent: :destroy

  before_validation :assign_status_to_comment, if: :new_comment?
  validates :candidate_id, uniqueness: { scope: :offer_id, message: "Existe déjà !" }
  # validates :consent, acceptance: { message: "Veuillez accepter les conditions" }
  validates :motivation_msg, presence: { message: "Veuillez indiquer la raison de votre refus" }, if: -> { active == false && origin != "company_user" && last_active_status == "selection" }
  validates :last_active_status, presence: {message: "Votre réponse est requise"}, on: :validation_step

  accepts_nested_attributes_for :candidate
  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: :no_comment_needed

  PERIODICITY = [
    "1 demi-journée par semaine",
    "1 jour par semaine",
    "1 jour toutes les 2 semaines",
    "Autre (préciser)"
  ]

  def clip_to_airtable
    unless offer.airtable_id.nil?
      @record = Aircandidacy.create(
        "Statut": self.sanitized_status,
        "Candidats": [candidate.airtable_id],
        "Offres": [offer.airtable_id]
        )
    end
  end

  def sanitized_status  # à harmoniser avec Paul sur Airtable
    case last_active_status
    when "user_application"
      "7. Intérêt asso"
    when "user_validation"
      "10. Mission en cours"
    when "user_rejection"
      "16. Refus candidat"
    when "admin_validation"
      "10. Mission en cours"
    when "admin_rejection"
      "10. Mission en cours"
    else
      nil
    end
  end

  def suggestion?
    active && last_active_status == "selection" && (origin == "company_admin" || origin == "admin")
  end

  def selection?
    active && last_active_status == "selection" && origin == "company_user"
  end

  def disliked?
    !active && last_active_status == "selection"
  end

  def abandonned?
    active == false && last_active_status != "selection"
  end

  def in_progress?
    active && last_active_status != "selection"
  end

  def validated?
    active && last_active_status == "mission"
  end

  def current_comment
    comments.find_by(status: last_active_status)
  end

  def new_comment?
    !comments.empty? && comments.last.id.nil?
  end

  def assign_status_to_comment
    comments.last.status = last_active_status
  end

  def no_comment_needed(attributes)
    attributes['content'].blank? && (
      ["user_application", "in_discussions"].include?(last_active_status) ||
      !current_comment.nil? ||
      (last_active_status == "selection" && origin == "company_user")
    )
  end
end
