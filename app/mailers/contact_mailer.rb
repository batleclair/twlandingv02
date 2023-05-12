class ContactMailer < ApplicationMailer
  def new_contact_email
    @contact = params[:contact]
    mail(to: [ENV['ADMIN_EMAIL'], ENV['ADMIN2_EMAIL']], subject: "Nouveau contact entrant ! 🥳")
  end
end
