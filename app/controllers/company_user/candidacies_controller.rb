class CompanyUser::CandidaciesController < CompanyUserController
  def index
    @candidacies = policy_scope(Candidacy)
  end

  def create
    @candidacy = Candidacy.new(candidacy_params)
    authorize @candidacy
    @offer = Offer.find_by(slug: params[:user_offer_slug])
    @candidacy.offer = @offer
    @candidacy.candidate = current_user.candidate
    if @candidacy.save
      align_selection
      redirect_back(fallback_location: user_offers_path)
      flash[:notice] = "Enregistré, nous informons l'association"
    else
      redirect_back(fallback_location: user_offers_path)
      flash[:alert] = "Un problème est survenu"
    end
  end

  private

  def candidacy_params
    params.require(:candidacy).permit(:motivation_msg)
  end

  def align_selection
    @selection = @candidacy.selection
    case
    when @selection.nil?
      create_selection
    when @selection.status="refused"
      @selection.update(status: "accepted")
    else
      return
    end
  end

  def create_selection
    Selection.create(offer_id: @candidacy.offer.id,
                    candidate_id: @candidacy.candidate.id,
                    response_msg: @candidacy.motivation_msg,
                    status: "accepted",
                    origin: "company_user")
  end
end
