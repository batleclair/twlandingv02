class CandidateMailer < ApplicationMailer
  def new_candidate_email
    @candidate = params[:candidate]
    mail(to: [ENV['ADMIN_EMAIL'], ENV['ADMIN2_EMAIL']], subject: "Nouveau candidat inscrit ! 🥳")
  end

  def new_profile_email
    @candidate = params[:candidate]
    mail(to: [ENV['ADMIN_EMAIL'], ENV['ADMIN2_EMAIL']], subject: "Nouveau questionnaire reçu ! 🥳")
  end
end
