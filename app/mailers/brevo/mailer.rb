module BrevoRoutes
  def routes
    host = ENV["REDISCLOUD_URL"] ? ENV["DOMAIN"] : "lvh.me:3000"
    Rails.application.routes.default_url_options = {host: host}
    Rails.application.routes.url_helpers
  end
end

class Brevo::Mailer
  extend BrevoRoutes

  def self.set_params
    @params = {
      'company_name': @user.company.name,
      'first_name': @user.first_name,
      'last_name': @user.last_name,
      'sub_domain': @user.company.slug,
      'link': @link,
    }
  end

  def self.build_brevo_mail
    Brevo::Mail.new(template_id: @template_id, to: @user.email, name: @user.first_name, params: @params)
  end
end
