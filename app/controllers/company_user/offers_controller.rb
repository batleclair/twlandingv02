class CompanyUser::OffersController < CompanyUserController
  before_action :set_tab, only: [:show, :index]

  def index
    @offers = policy_scope(Offer)
  end

  def show
    @offer = Offer.find_by(slug: params[:slug])
    authorize @offer
    @selection = Candidacy.find_by(offer_id: @offer.id, candidate_id: current_user.candidate.id) || Candidacy.new
    @selection_on_record = @selection
    session[:selection_error] = true
  end

  private

  def set_tab
    @tab = 1
  end
end
