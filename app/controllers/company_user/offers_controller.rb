class CompanyUser::OffersController < CompanyUserController
  def index
    @offers = policy_scope(Offer)
  end

  def show
    @offer = Offer.find_by(slug: params[:slug])
    authorize @offer
    @candidacy = Candidacy.find_by(offer_id: @offer.id, candidate_id: current_user.candidate.id) || Candidacy.new
  end
end
