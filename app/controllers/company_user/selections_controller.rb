class CompanyUser::SelectionsController < CompanyUserController
  before_action :set_selection, only: [:show, :update]
  before_action :set_selections, only: [:show, :index]
  before_action :set_tab, only: [:show, :index]

  def index
  end

  def show
    session.delete(:selection_error)
    render show_view
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
      flash[:notice] = "Ajouté à vos favoris"
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
      render show_view, status: :unprocessable_entity
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
    scope = policy_scope(Candidacy)
    case params[:type]
    when "suggestions"
      scope = scope.where(origin: ["company_admin", "admin"])
      @subtab = 1
    when "selections"
      scope = scope.where(origin: "company_user")
      @subtab = 2
    when "approved"
      scope = scope.where.not(status: "selection")
      @subtab = 3
    when "rejections"
      scope = scope.where(active: false, status: "selection")
      @subtab = 4
    else
      @subtab = @selection_on_record.nil? ? 0 : set_subtab
    end
    @selections = scope.where(status: "selection")
    @candidacies = scope.where.not(status: "selection")
  end

  def selection_params
    params.require(:candidacy).permit(:status, :active, :motivation_msg)
  end

  def set_subtab
    selection_tabs = {
      suggestion: 1,
      selection: 2,
      candidacy: 3,
      rejection: 4
    }
    status = @selection_on_record.selection_status
    @subtab = @selection_on_record.nil? ? 0 : selection_tabs[status]
  end

  def show_view
    selection_views = {
      suggestion: :show_suggestion,
      selection: :show_selection,
      candidacy: :show_approved,
      rejection: :show_rejection
    }
    status = @selection_on_record.selection_status
    return session[:selection_error] ? "company_user/offers/show" : selection_views[status]
  end
end
