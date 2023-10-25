class CompanyUser::OffersController < CompanyUserController
  def index
    @offers = policy_scope(Offer)
  end

  def show
    @offer = Offer.find_by(slug: params[:slug])
    authorize @offer
    @selection = Candidacy.find_by(offer_id: @offer.id, candidate_id: current_user.candidate.id) || Candidacy.new
    @selection_on_record = @selection
    session[:failed_candidacy_path] = "company_user/offers/show"
  end
end
