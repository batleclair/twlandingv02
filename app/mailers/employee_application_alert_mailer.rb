class EmployeeApplicationAlertMailer < BrevoMailer
  def email(user, employee_application)
    @user = user
    @employee_application = employee_application

    # Initialize a new email
    @email = SibApiV3Sdk::SendSmtpEmail.new
    # Setup email attributes
    @email.sender = {
      "name": "Your name",
      "email": "yourname@example.com"
    }
    @email.to = [{ "email": @user.email }]
    @email.html_content = html("<p>String with your html email</p>")
    @email.text_content = text("String with your plain text email")
    @email.subject = "Your subject line"
    @email.reply_to = {
      "email": "yourname@example.com",
      "name": "Your name"
    }
    # Send your email
    @send_in_blue.send_transac_email(@email)
  end
end
