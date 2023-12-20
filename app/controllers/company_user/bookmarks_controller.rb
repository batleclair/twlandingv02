class CompanyUser::BookmarksController < CompanyUserController

  def index
    scope = policy_scope(Candidacy).where(origin: "company_user", active: true)
    @selections = scope.where(status: "selection")
    @candidacies = scope.where.not(status: "selection")
    authorize @selections
    @tab = 2
  end

  def show
    set_selection
    @tab = 2
    redirect_to user_bookmarks_path if !@selection.active
  end

  def create
    @selection = Candidacy.new(selection_params)
    authorize @selection
    @offer = Offer.find_by(slug: params[:user_offer_slug])
    @selection.offer = @offer
    @selection.candidate = current_user.candidate
    @selection.origin = "company_user"
    @selection.status = "selection"
    if @selection.save
      respond_to do |format|
        format.turbo_stream {render turbo_stream: turbo_stream.replace("selection", partial: "company_user/offers/selection")}
        format.html {redirect_to user_bookmark_path(@selection)}
      end
    else
      redirect_back(fallback_location: user_offers_path)
      flash[:alert] = "Une erreur s'est produite"
    end
  end

  def update
    set_selection
    @selection.assign_attributes(selection_params)
    if @selection.save(context: :validation_step)
      respond_to do |format|
        format.turbo_stream {render "company_user/offers/selection"}
        format.html {redirect_to user_bookmark_path(@selection)}
      end
    else
      @tab = 2
      render :show, status: :unprocessable_entity
      flash[:alert] = "Une erreur s'est produite"
    end
  end

  def destroy
    set_selection
    @offer = @selection.offer
    @selection.destroy
    @selection = Candidacy.new
    respond_to do |format|
      format.turbo_stream {render turbo_stream: turbo_stream.replace("selection", partial: "company_user/offers/selection")}
      format.html {redirect_to user_bookmarks_path, status: :see_other}
    end
  end

  private

  def selection_params
    params.require(:candidacy).permit(:status, :active, :motivation_msg)
  end

  def set_selection
    @selection = Candidacy.find(params[:id])
    authorize @selection
    @selection_on_record = Candidacy.find(params[:id])
  end
end
