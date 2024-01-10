class Brevo::WhitelistMailer < Brevo::Mailer
  def self.invitation_email_for(whitelist)
    link = routes.new_user_registration_url(
      subdomain: whitelist.company.slug,
      first_name: whitelist.first_name,
      last_name: whitelist.last_name,
      email: whitelist.email
      )
    params = {
      'company_name': whitelist.company.name,
      'first_name': whitelist.first_name,
      'last_name': whitelist.last_name,
      'sub_domain': whitelist.company.slug,
      'link': link
    }
    Brevo::Mail.new(template_id: 8, to: whitelist.email, name: whitelist.first_name, params: params)
  end
end
