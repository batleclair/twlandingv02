class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, presence: {message: "Un commentaire est requis"}, unless: [:candidacy_exceptions, :mission]
  validates :commentable_type, uniqueness: {
    scope: [ :commentable_id, :status ],
    message: "Un commentaire a déjà été attribué à ce statut"
  }, if: :candidacy

  def candidacy_exceptions
    candidacy && (
      commentable.selection_status? ||
      commentable.user_application_status? ||
      commentable.in_discussions_status? ||
      (commentable.user_validation_status? && commentable.active)
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
