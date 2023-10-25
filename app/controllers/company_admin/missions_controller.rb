class CompanyAdmin::MissionsController < CompanyAdminController
before_action :set_missions_and_candidacies, only: [:index, :show, :new, :update]

  def index
  end

  def show
    @mission = Mission.find(params[:id])
    @contract = Contract.new
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @candidacy = Candidacy.find(params[:company_admin_candidacy_id])
    @mission = Mission.new(candidacy: @candidacy)
    authorize @mission
    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @mission = Mission.new(mission_params)
    @candidacy = Candidacy.find(params[:company_admin_candidacy_id])
    @mission.candidacy = @candidacy
    if @mission.save
      redirect_to company_admin_mission_path(@mission)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @mission = Mission.find(params[:id])
    @candidacy = @mission.candidacy
    @mission.assign_attributes(full_mission_params)
    if @mission.save
      redirect_back(fallback_location: company_admin_mission_path(@mission))
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_missions_and_candidacies
    @missions = policy_scope(Mission)
    @candidacies = policy_scope(Candidacy).where(active: true, status: "mission").select{|c| !c.mission.present?}
  end

  def mission_params
    params.require(:mission).permit(
      :title,
      :start_date,
      :end_date,
      :periodicity,
      :days_count,
      :referent_name,
      :referent_email,
      :description,
      :mission_type,
      :feedback_on,
      :feedback_step,
      :feedback_unit,
      :feedback_start,
      :manager_approval,
      :beneficiary_approval,
      :employee_approval,
      :status,
      contracts_attributes: [:title, :contract_type, :document]
    )
  end

  def full_mission_params
    if params.require(:mission)[:contracts_attributes].present?
      mission_params.to_h.deep_merge({contracts_attributes: {"0": {company_id: current_user.company_id}}})
    else
      mission_params
    end
  end
end
