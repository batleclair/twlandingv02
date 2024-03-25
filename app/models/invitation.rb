class Invitation < ApplicationRecord
  # acts_as_taggable_on :skills
  validates :email, uniqueness: {message: "Invitation déjà envoyée"}
  validate :no_user
  after_commit :send_invite_email, on: :create

  def no_user
    if User.find_by(email: email)
      errors.add(:email, "Utilisateur déjà inscrit")
    end
  end

  def send_invite_email
    Brevo::InvitationMailer.invitation_email_for(self).deliver
  end

end
