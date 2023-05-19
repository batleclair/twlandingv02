class UserMailer < ApplicationMailer
  def new_user_email(user)
    @user = user
    attachments.inline["logo_dark.png"] = File.read("#{Rails.root}/app/assets/images/logo_dark.png")
    attachments.inline["profile_btn.png"] = File.read("#{Rails.root}/app/assets/images/profile_btn.png")
    attachments.inline["missions_btn.png"] = File.read("#{Rails.root}/app/assets/images/missions_btn.png")
    mail(to: @user.email, subject: "Bienvenue chez Demain ! 🙌")
  end

  def user_invite_email(user, token)
    @user = user
    @token = token
    attachments.inline["logo_dark.png"] = File.read("#{Rails.root}/app/assets/images/logo_dark.png")
    attachments.inline["complete_btn.png"] = File.read("#{Rails.root}/app/assets/images/complete_btn.png")
    mail(to: @user.email, subject: "Votre invitation Demain ! 🙌")
  end
end
