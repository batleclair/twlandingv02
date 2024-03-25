class Brevo::InvitationMailer < Brevo::Mailer

  def self.invitation_email_for(invitation)
    @template_id = 23
    @user = invitation
    @link = routes.new_user_registration_url(
      first_name: invitation.first_name,
      last_name: invitation.last_name,
      email: invitation.email
      )
    set_user_recipient
    @params = {
      'first_name': @user.first_name,
      'last_name': @user.last_name,
      'link': @link,
    }
    build_brevo_mail
  end

end
