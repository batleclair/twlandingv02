class Brevo::CandidacyMailer < Brevo::Mailer

  def self.new_suggestion(suggestion)
    @template_id = brevo_template(:selection)
    @user = suggestion.user
    @link = routes.user_selection_url(
      subdomain: @user.company.slug,
      id: suggestion.id
    )
    set_user_recipient
    set_params
    @params[:sender] = suggestion.origin
    @params[:beneficiary_name] = suggestion.beneficiary.name
    @params[:offer_title] = suggestion.offer.title
    build_brevo_mail
  end

  def self.new_response(candidacy)
    @template_id = brevo_template(candidacy.status.to_sym)
    @user = candidacy.user
    @link = routes.user_candidacy_url(
      subdomain: @user.company.slug,
      id: candidacy.id
    )
    set_user_recipient
    set_params
    @params[:beneficiary_name] = candidacy.beneficiary.name
    @params[:offer_title] = candidacy.offer.title
    @params[:approved] = candidacy.active
    @params[:message] = candidacy.send("#{candidacy.status}_message").content
    build_brevo_mail
  end


  def self.admin_submission(candidacy)
    @template_id = brevo_template(candidacy.status.to_sym)
    @company = candidacy.user.company
    @link = routes.company_admin_candidacy_url(
      subdomain: @company.slug,
      id: candidacy.id
    )
    set_admin_recipients
    set_admin_params
    @params[:first_name] = @company.name
    @params[:candidate_name] = candidacy.candidate.full_name
    build_brevo_mail
  end

  private

  def self.brevo_template(status)
    brevo_templates = {
      selection: 14,
      beneficiary_validation: 16,
      user_validation: 20,
      admin_validation: 17,
      mission: 17
    }
    brevo_templates[status]
  end
end
