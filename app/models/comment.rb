class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, presence: true, unless: [:candidacy_exceptions, :mission]
  validates :commentable_type, uniqueness: {
    scope: [ :commentable_id, :status ],
    message: "Un commentaire a déjà été attribué à ce statut"
  }, if: :candidacy

  def candidacy_exceptions
    commentable_type == "Candidacy" && (
      commentable.last_active_status == "selection" ||
      commentable.last_active_status == "user_application" ||
      commentable.last_active_status == "in_discussions"
    )
  end

  def candidacy
    commentable_type == "Candidacy"
  end

  def mission
    commentable_type == "Mission"
  end

  # def candidacy_rejection
  #   commentable_type == "Candidacy" && commentable.active && commentable.comments.where(status: status).length == 1
  # end

end
