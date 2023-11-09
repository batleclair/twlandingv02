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

  def update
    @selection.assign_attributes(selection_params)
    # set_active_upon_application
    if @selection.save(context: :validation_step)
      redirect_to user_selections_path
      flash[:notice] = "Enregistré !"
    else
      set_tab
      @error = true
      render :show, status: :unprocessable_entity
      flash[:alert] = "Une erreur s'est produite"
    end
  end

  private

  def set_selection
    @selection = Candidacy.find(params[:id])
    authorize @selection
    @selection_on_record = Candidacy.find(params[:id])
  end

  # def set_active_upon_application
  #   @selection.active = true if @selection.status == "user_application" && @selection_on_record.status == "selection"
  # end

  def set_tab
    @tab = 3
  end

  def set_selections
    scope = policy_scope(Candidacy).where(origin: ["company_admin", "admin"])
    @selections = scope.where(status: "selection", active: true)
    @candidacies = scope.where.not(status: "selection").where(active: true)
    @rejections = scope.where(status: "selection", active: false)
  end

  def selection_params
    params.require(:candidacy).permit(:status, :active, :motivation_msg)
  end

  def show_view
    selection_views = {
      suggestion: :show,
      candidacy: :show_approved,
      rejection: :show_rejection
    }
    return selection_views[@selection_on_record.selection_status]
  end
end
