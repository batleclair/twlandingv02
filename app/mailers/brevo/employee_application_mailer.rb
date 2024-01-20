class Brevo::EmployeeApplicationMailer < Brevo::Mailer
  def self.send_response_email(employee_application)
    @template_id = 13
    @user = employee_application.user
    @link = routes.user_offers_url(subdomain: @user.company.slug)
    set_user_recipient
    set_params
    @params[:on_boarded] = @user.on_boarding_completed?
    @params[:status] = employee_application.status
    @params[:message] = employee_application.response_msg
    build_brevo_mail
  end

  def self.new_request(employee_application)
    @template_id = 21
    @company = employee_application.company
    @link = routes.company_admin_employee_application_url(
      subdomain: @company.slug,
      id: employee_application.id
      )
    set_admin_recipients
    set_admin_params
    @params[:first_name] = @company.name
    @params[:candidate_name] = employee_application.candidate.full_name
    @params[:message] = employee_application.motivation_msg
    build_brevo_mail
  end
end
