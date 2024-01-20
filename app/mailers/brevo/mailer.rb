module BrevoHelpers
  def routes
    host = ENV["REDISCLOUD_URL"] ? ENV["DOMAIN"] : "lvh.me:3000"
    Rails.application.routes.default_url_options = {host: host}
    Rails.application.routes.url_helpers
  end

  def set_params
    @params = {
      'company_name': @user.company.name,
      'first_name': @user.first_name,
      'last_name': @user.last_name,
      'sub_domain': @user.company.slug,
      'link': @link,
    }
  end

  def set_admin_params
    @params = {
      'company_name': @company.name,
      'sub_domain': @company.slug,
      'link': @link,
    }
  end

  def set_user_recipient
    @to = [{email: @user.email, name: @user.first_name}]
  end

  def set_admin_recipients
    @to = []
    User.where(company_id: @company.id, company_role: :admin).each {|user| @to << {email: user.email, name: user.first_name}}
  end

  def build_brevo_mail
    Brevo::Mail.new(to: @to, template_id: @template_id, params: @params)
  end
end

class Brevo::Mailer
  extend BrevoHelpers
end
