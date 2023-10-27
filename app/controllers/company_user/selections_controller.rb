class CompanyUser::SelectionsController < CompanyUserController
  include ControllerUtilities
  before_action :set_selection, only: [:show, :update]
  before_action :set_selections, only: [:show, :index]
  before_action :set_tab, only: [:show, :index]

  def index
  end

  def show
    render_show_view
  end

  def create
    @selection = Candidacy.new(selection_params)
    authorize @selection
    @offer = Offer.find_by(slug: params[:user_offer_slug])
    @selection.offer = @offer
    @selection.candidate = current_user.candidate
    @selection.origin = "company_user"
    @selection.active = true
    @selection.status = "selection"
    if @selection.save
      redirect_back(fallback_location: user_offers_path)
      flash[:notice] = "Ajouté à vos coups de 💜"
    else
      redirect_back(fallback_location: user_offers_path)
      flash[:alert] = "Une erreur s'est produite"
    end
  end

  def update
    @selection.assign_attributes(selection_params)
    set_active_upon_application
    if @selection.save(context: :validation_step)
      redirect_back(fallback_location: user_selection_path(@selection))
      flash[:notice] = "Enregistré !"
    else
      path = session[:failed_candidacy_path]
      if legit?(path)
        @offer = @selection.offer
        render path, status: :unprocessable_entity
      end
      flash[:alert] = "Une erreur s'est produite"
    end
  end

  private

  def set_selection
    @selection = Candidacy.find(params[:id])
    authorize @selection
    @selection_on_record = Candidacy.find(params[:id])
  end

  def set_active_upon_application
    @selection.active = true if @selection.status == "user_application" && @selection_on_record.status == "selection"
  end

  def set_tab
    @tab = 2
  end

  def set_selections
    case params[:type]
    when "suggestions"
      @selections = policy_scope(Candidacy).select{|s| s.suggestion?}
    when "selections"
      @selections = policy_scope(Candidacy).select{|s| s.selection?}
    when "rejections"
      @selections = policy_scope(Candidacy).select{|s| s.disliked?}
    else
      @selections = policy_scope(Candidacy)
    end
  end

  def selection_params
    params.require(:candidacy).permit(:status, :active, :motivation_msg)
  end

  def render_show_view
    case
    when @selection.suggestion?
      session[:failed_candidacy_path] = "company_user/selections/show_suggestion"
      render :show_suggestion
    when @selection.selection?
      session[:failed_candidacy_path] = "company_user/selections/show_selection"
      render :show_selection
    when @selection.abandonned? || @selection.disliked?
      session[:failed_candidacy_path] = "company_user/selections/show_rejection"
      render :show_rejection
    when @selection.in_progress?
      redirect_to user_candidacy_path(@selection)
    else
      return
    end
  end
end
