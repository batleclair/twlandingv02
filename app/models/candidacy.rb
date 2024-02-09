class Candidacy < ApplicationRecord
  belongs_to :candidate
  belongs_to :offer
  has_one :beneficiary, through: :offer
  has_one :mission, dependent: :destroy
  has_one :user, through: :candidate
  has_many :comments, as: :commentable, dependent: :destroy

  before_validation :assign_status_to_comment, if: :new_comment?
  validates :candidate_id, uniqueness: { scope: :offer_id, message: "Existe déjà !" }
  validates :motivation_msg, length: { minimum: 1, message: "Un message est requis" }, if: -> { active == false && origin != "company_user" && status == "selection" }, on: :validation_step
  validates :motivation_msg, length: { minimum: 1, message: "Veuillez indiquer vos motivations" }, if: -> { active == true && status == "user_application" }, on: :validation_step
  validates :status, presence: {message: "Votre réponse est requise"}, on: :validation_step
  validates :active, length: { minimum: 1, message: "Votre réponse est requise"}, on: :validation_step
  validates :req_description, presence: {message: "Description requise"}, allow_nil: true
  # validates :manager_validation, acceptance: { message: 'Double-validation requise' }, if: :mission_status?, on: :validation_step

  enum :origin, {company_admin: 0, company_user: 1, admin: 2}, suffix: true
  enum :status, { selection: 0,
    user_application: 1, #candidacy submitted to beneficiary
    beneficiary_application: 2, #beneficiary confirmed interest
    in_discussions: 3, #cross-intro done
    beneficiary_validation: 4, #beneficiary confirmed interest, candidate needs to refuse or accept+submit request for company_admin approval
    user_validation: 5, #request submited awaiting company_admin validation
    admin_validation: 6,  #request declined
    mission: 7 #mission created
    }, suffix: true

  accepts_nested_attributes_for :candidate
  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: :no_comment_needed
  scope :status_as, -> (status) { status.nil? ? order(status: :asc, created_at: :desc) : where(status: status).order(status: :asc, created_at: :desc) }

  after_commit :auto_approve_beneficiary_steps, on: [:create, :update]
  after_create -> {send_notification(:new_suggestion)}, if: :suggestion?
  after_update -> {send_notification(:new_response)}, if: :notifiable?

  PERIODICITY = [
    "1 demi-journée par semaine",
    "1 jour par semaine",
    "1 jour toutes les 2 semaines",
    "Autre (préciser)"
  ]

  def readable_statuses
    {
      user_application: "Candidature de #{candidate.user.first_name}",
      beneficiary_application: "Candidature acceptée par #{beneficiary.name}",
      in_discussions: "Entretiens entre #{candidate.user.first_name} et #{beneficiary.name}",
      beneficiary_validation: "Candidature validée par #{beneficiary.name}",
      user_validation: "Candidature confirmée par #{candidate.user.first_name}",
      admin_validation: "Candidature refusée par #{candidate.user.company.name}",
      mission: "Candidature approuvée par #{candidate.user.company.name}"
    }
  end

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
    case status
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
    active && selection_status? && ( company_admin_origin? || admin_origin? )
  end

  def selection?
    active && selection_status? && company_user_origin?
  end

  def disliked?
    !active && selection_status?
  end

  def abandonned?
    !active && !selection_status? && !mission.present?
  end

  def in_progress?
    active && !selection_status?
  end

  def selection_status
    case
    when selection?
      :selection
    when suggestion?
      :suggestion
    when disliked?
      :rejection
    when !selection_status?
      :candidacy
    end
  end

  def being_assessed?
    active && (
      user_application_status? ||
      beneficiary_application_status? ||
      in_discussions_status?
    )
  end

  def being_validated?
    active && (
      beneficiary_validation_status? ||
      user_validation_status? ||
      admin_validation_status?
    )
  end

  def submitted_for_approval?
    active && user_validation_status?
  end

  def validated?
    active && mission_status?
  end

  def validation_status
    case
    when being_assessed?
      :assessing
    when being_validated?
      :validating
    when abandonned?
      :abandonned
    when validated? || mission.present?
      :approved
    end
  end

  def current_comment
    comments.find_by(status: status)
  end

  def new_comment?
    !comments.empty? && comments.last.id.nil?
  end

  def assign_status_to_comment
    comments.last.status = status
  end

  def no_comment_needed(attributes)
    attributes['content'].blank? && (
      !current_comment.nil? ||
      (user_application_status? || in_discussions_status?) ||
      (selection_status? && (company_user_origin? || admin_origin?)) ||
      (user_validation_status? && active)
    )
  end

  def self.previous_status(candidacy)
    if statuses[candidacy.status] == 0
      return nil
    else
      return statuses.key(statuses[candidacy.status] -1)
    end
  end

  def self.next_status(candidacy)
    return statuses.key(statuses[candidacy.status] +1)
  end

  def created_ago
    e = (Date.today - Date.parse(created_at.to_s)).to_i
    if e == 0
      "aujourd'hui"
    elsif e == 1
      "hier"
    elsif e > 1 && e < 7
      "#{e} jours"
    elsif e >= 7 && e < 14
      "#{e.fdiv(7).floor} semaine"
    elsif e >= 7 && e < 30
      "#{e.fdiv(7).floor} semaines"
    elsif e >= 30 && e <= 365
      "#{e.fdiv(30).floor} mois"
    else
      "+ d'1 an"
    end
  end

  def high_level_status
    case
    when suggestion? || selection? || disliked?
      "sélection"
    when (in_progress? && !mission.present?) || abandonned?
      "candidature"
    when mission.present?
      "mission"
    end
  end

  def status_of(step)
    h_active = {
      step_1: "pass",
      step_2: user_application_status? ? "ongoing" : ( self.class.statuses[status] > 1 ? "pass" : "pending" ),
      step_3: beneficiary_application_status? ? "ongoing" : ( self.class.statuses[status] > 2 ? "pass" : "pending" ),
      step_4: in_discussions_status? ? "ongoing" : ( self.class.statuses[status] > 3 ? "pass" : "pending" ),
      step_5: beneficiary_validation_status? ? "ongoing" : ( self.class.statuses[status] > 4 ? "pass" : "pending" ),
      step_6: user_validation_status? ? "ongoing" : ( self.class.statuses[status] > 5 ? "pass" : "pending")
    }

    h_inactive = {
      step_1: "pass",
      step_2: user_application_status? || beneficiary_application_status? ? "fail" : ( self.class.statuses[status] > 2 ? "pass" : "pending" ),
      step_3: in_discussions_status? ? "fail" : ( self.class.statuses[status] > 3 ? "pass" : "pending"),
      step_4: beneficiary_validation_status? ? "fail" : ( self.class.statuses[status] > 4 ? "pass" : "pending"),
      step_5: user_validation_status? ? "fail" : ( self.class.statuses[status] > 5 ? "pass" : "pending"),
      step_6: admin_validation_status? ? "fail" : "pending"
    }

    active ? h_active[step] : h_inactive[step]
  end

  def self.approval_statuses
    {
      "A traîter": :user_validation,
      "Validées": :mission,
      "Refusées": :admin_validation,
    }
  end

  self.statuses.keys.each do |status|
    define_method "#{status}_message" do
      self.comments&.find_by(status: status)
    end
  end

  def auto_approve_beneficiary_steps
    if active && candidate.user.company.demo_status? && user_application_status?
      Comment.create(status: "beneficiary_application", commentable_type: "Candidacy", user_id: User.find_by_email("baptiste@demain.works").id, commentable_id: id, content: "Nous serions très intéressés d'échanger avec vous.")
      Comment.create(status: "in_discussions", commentable_type: "Candidacy", user_id: User.find_by_email("baptiste@demain.works").id, commentable_id: id, content: "Vous êtes désormais en relation avec l'association")
      Comment.create(status: "beneficiary_validation", commentable_type: "Candidacy", user_id: User.find_by_email("baptiste@demain.works").id, commentable_id: id, content: "Merci pour cet échange téléphonique, je te confirme que nous serions heureux de bénéficier de ton expertise sur le sujet !")
      beneficiary_validation_status!
    end
  end

  def send_notification(action)
    Brevo::CandidacyMailer.send(action, self).deliver
  end

  def notifiable?
    beneficiary_validation_status? ||
    (mission_status? && active) ||
    (admin_validation_status? && !active)
  end
end
