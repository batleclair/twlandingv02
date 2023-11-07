class CompanyAdmin::OffersController < CompanyAdminController
  before_action :set_tab

  def index
    @offers = policy_scope(Offer)
    @no_offer = Offer.find_by(title: "no_offer")
  end

  def show
    @offer = Offer.find_by(slug: params[:slug])
    @candidacy = Candidacy.new
    @candidates = policy_scope(Candidate).select{|c| c.user.last_employee_application&.approved_status?}
    @selected_candidates = @candidates.select{|c| c.candidacies.find_by(offer_id: @offer.id).present?}
  end

  private

  def set_tab
    @tab = 1
  end
end
