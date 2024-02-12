class Brevo::DeviseMailer < Devise::Mailer
  require 'brevo/mailer'
  extend BrevoHelpers

  def self.confirmation_instructions(record, token, opts={})
    @template_id = 9
    @to = [{email: record.email, name: record.first_name}]
    @link = routes.user_confirmation_url(
      subdomain: record.company.slug,
      confirmation_token: token
    )
    @params = {'link': @link}
    build_brevo_mail
  end

  def self.reset_password_instructions(record, token, opts = {})
    @template_id = 22
    @to = [{email: record.email, name: record.first_name}]
    @link = routes.edit_user_password_url(
      subdomain: record.company.slug,
      reset_password_token: token
    )
    @params = {'link': @link}
    build_brevo_mail
  end
end
