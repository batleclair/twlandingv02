class UserMailer < ApplicationMailer
  def new_user_email(user)
    @user = user
    attachments.inline["logo_dark.png"] = File.read("#{Rails.root}/app/assets/images/logo_dark.png")
    mail(to: @user.email, subject: "Bienvenue chez Demain ! 🙌")
  end
end
