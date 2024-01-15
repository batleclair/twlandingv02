class Brevo::CandidacyMailer < Brevo::Mailer

  def self.new_suggestion(suggestion)
    user = suggestion.user
    link = routes.user_selection_url(
      subdomain: user.company.slug,
      id: suggestion.id
      )
    params = {
      'company_name': user.company.name,
      'first_name': user.first_name,
      'last_name': user.last_name,
      'sub_domain': user.company.slug,
      'link': link,
      'sender': suggestion.origin,
      'beneficiary_name': suggestion.beneficiary.name,
      'offer_title': suggestion.offer.title
    }
    id = brevo_template(:selection)
    Brevo::Mail.new(template_id: id, to: user.email, name: user.first_name, params: params)
  end

  def self.new_response(candidacy)
    user = candidacy.user
    link = routes.user_candidacy_url(
      subdomain: user.company.slug,
      id: candidacy.id
      )
    params = {
      'company_name': user.company.name,
      'first_name': user.first_name,
      'last_name': user.last_name,
      'sub_domain': user.company.slug,
      'link': link,
      'beneficiary_name': candidacy.beneficiary.name,
      'offer_title': candidacy.offer.title,
      'approved': candidacy.active,
      'message': candidacy.send("#{candidacy.status}_message").content
    }
    id = brevo_template(candidacy.status.to_sym)
    Brevo::Mail.new(template_id: id, to: user.email, name: user.first_name, params: params)
  end

  private

  def self.brevo_template(status)
    brevo_templates = {
      selection: 14,
      beneficiary_validation: 16,
      admin_validation: 17,
      mission: 17
    }
    brevo_templates[status]
  end
end
