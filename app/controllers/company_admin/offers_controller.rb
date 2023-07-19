class CompanyAdmin::OffersController < CompanyAdminController
  def index
    @offers = policy_scope(Offer)
    @no_offer = Offer.find_by(title: "no_offer")
  end

  def show
    @offer = Offer.find_by(slug: params[:slug])
    @selection = Selection.new
    @candidates = policy_scope(Candidate).select{|c| c.user.last_employee_application&.approved?}
    @selected_candidates = @candidates.select{|c| c.selections.find_by(offer_id: @offer.id).present?}
  end
end
