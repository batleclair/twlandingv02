class CompanyUser::OffersController < CompanyUserController
  def index
    @offers = policy_scope(Offer)
  end

  def show
    @offer = Offer.find_by(slug: params[:slug])
    authorize @offer
    @candidacy = Candidacy.new
    @selection = @offer.selection_by(current_user)
  end
end
