class Brevo::WhitelistMailer < Brevo::Mailer

  def self.invitation_email_for(whitelist)
    @template_id = whitelist.admin_role? ? 12 : 8
    @user = whitelist
    @link = routes.new_user_registration_url(
      subdomain: whitelist.company.slug,
      first_name: whitelist.first_name,
      last_name: whitelist.last_name,
      email: whitelist.email
      )
    set_user_recipient
    set_params
    build_brevo_mail
  end

end
