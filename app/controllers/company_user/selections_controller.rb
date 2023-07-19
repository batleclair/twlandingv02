class CompanyUser::SelectionsController < CompanyUserController

  def show
    @selection = Selection.find(params[:id])
    authorize @selection
    @candidacy = Candidacy.new
    respond_to do |format|
      format.html
      format.json
    end
  end

  def index
    @selections = policy_scope(Selection)
  end

  def create
    @selection = Selection.new
    @selection.candidate = current_user.candidate
    authorize @selection
    @offer = Offer.find_by(slug: params[:user_offer_slug])
    @selection.offer = @offer
    @selection.origin = "company_user"
    if @selection.save
      redirect_back(fallback_location: user_offers_path)
      flash[:notice] = "Ajouté à vos sélections"
    else
      redirect_back(fallback_location: user_offers_path)
      flash[:alert] = "Un problème est survenu"
    end
  end

  def update
    @selection = Selection.find(params[:id])
    authorize @selection
    @selection.update(selection_params)
    if @selection.save
      create_candidacy if @selection.status == "accepted"
      redirect_back(fallback_location: selections_path)
      flash[:notice] = "Enregistré, nous informons l'association"
    else
      render :show, status: :unprocessable_entity
      flash[:alert] = "Un problème est survenu"
    end
  end

  def destroy
    @selection = Selection.find(params[:id])
    authorize @selection
    redirect_to user_offers_path(@selection.offer), status: :see_other
  end

  private

  def selection_params
    params.require(:selection).permit(:status, :response_msg)
  end

  def create_candidacy
    @candidacy = Candidacy.create(offer: @selection.offer, candidate: @selection.candidate, motivation_msg: @selection.response_msg)
  end

end
