class Brevo::EmployeeApplicationMailer < Brevo::Mailer
  def self.send_response_email(employee_application)
    user = employee_application.user
    link = routes.user_offers_url(subdomain: user.company.slug)
    params = {
      'company_name': user.company.name,
      'first_name': user.first_name,
      'last_name': user.last_name,
      'on_boarded': user.on_boarding_completed?,
      'link': link,
      'sub_domain': user.company.slug,
      'status': employee_application.status,
      'message': employee_application.response_msg
    }
    id = 13
    Brevo::Mail.new(template_id: id, to: user.email, name: user.first_name, params: params)
  end
end
