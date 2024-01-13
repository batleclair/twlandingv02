module BrevoRoutes
  def routes
    Rails.application.routes.default_url_options = {host: (Rails.env.development? ? "lvh.me:3000" : "demain.works")}
    Rails.application.routes.url_helpers
  end
end

class Brevo::Mailer
  extend BrevoRoutes
end
