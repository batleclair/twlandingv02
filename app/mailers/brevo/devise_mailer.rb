class Brevo::DeviseMailer < Devise::Mailer
  require 'brevo/mailer'
  extend BrevoRoutes

  def self.confirmation_instructions(record, token, opts={})
    link = routes.user_confirmation_url(confirmation_token: token)
    params = {
      'link': link
    }
    b = Brevo::Mail.new(template_id: 9, to: record.email, name: record.first_name, params: params)
  end
end
