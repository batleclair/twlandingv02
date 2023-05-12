# Preview all emails at http://localhost:3000/rails/mailers/candidate_mailer
class CandidateMailerPreview < ActionMailer::Preview
  def new_candidate_email
    candidate = User.find_by(email: "baptiste@demain.works").candidate
    CandidateMailer.with(candidate: candidate).new_candidate_email
  end

  def new_profile_email
    candidate = User.find_by(email: "baptiste@demain.works").candidate
    CandidateMailer.with(candidate: candidate).new_profile_email
  end
end
