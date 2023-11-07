class CompanyAdmin::MissionsController < CompanyAdminController
before_action :set_missions_and_candidacies
before_action :set_tab
before_action :set_mission, only: [:show, :checklist, :terms, :counterparts, :documents]
before_action :redirect_if_active, only: [:checklist, :terms, :counterparts, :documents]

  def index
  end

  def show
    if @mission.draft_status?
      redirect_to company_admin_mission_checklist_path(@mission, view: params[:view])
    elsif @mission.activated_status?
      render :activated
    end
  end

  def checklist
    @steptab = 0
    session[:mission_error] = "checklist"
  end

  def counterparts
    @steptab = 1
    session[:mission_error] = "counterparts"
  end

  def terms
    @steptab = 2
    session[:mission_error] = "terms"
  end

  def documents
    @steptab = 3
    @contract = Contract.new
    session[:mission_error] = "documents"
  end

  def new
    @candidacy = Candidacy.find(params[:company_admin_candidacy_id])
    @mission = Mission.new(candidacy: @candidacy)
    authorize @mission
  end

  def create
    @mission = Mission.new(mission_params)
    @candidacy = Candidacy.find(params[:company_admin_candidacy_id])
    @mission.candidacy = @candidacy
    if @mission.save
      redirect_to company_admin_mission_path(@mission)
    else
      set_tab
      set_missions_and_candidacies
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @mission = Mission.find(params[:id])
    @candidacy = @mission.candidacy
    @mission.assign_attributes(mission_params)
    assign_company_to_contract
    if @mission.save && candidate_update
      redirect_to company_admin_mission_path(@mission)
    else
      set_tab
      @error = true
      set_subtab
      render session[:mission_error].to_sym, status: :unprocessable_entity
    end
  end

  private

  def set_missions_and_candidacies
    missions = policy_scope(Mission)
    candidacies = policy_scope(Candidacy).where(active: true, status: "mission").select{|c| !c.mission.present?}
    case params[:view]
    when "new"
      @candidacies = candidacies
    when "in_progress"
      @missions = missions.where(status: "draft")
    when "activated"
      @missions = missions.where(status: "activated")
    else
      @candidacies = candidacies
      @missions = missions
    end
  end

  def set_tab
    @tab = 5
  end

  def set_subtab
    subtabs = {checklist: 0, counterparts: 1, terms: 2, documents: 3}
    view = session[:mission_error].to_sym
    @steptab = subtabs[view]
  end

  def set_mission
    @mission = Mission.find(params[:id])
    authorize @mission
  end

  def redirect_if_active
    if @mission.activated_status?
      redirect_to company_admin_mission_path(@mission)
    end
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

  def assign_company_to_contract
    @mission.contracts.last.company_id = current_user.company_id if @mission.new_contract?
  end

  def candidate_update
    @mission.candidate.update(params.require(:candidate).permit(:referent_name, :referent_email)) if params[:candidate].present?
  end

  # def full_mission_params
  #   if params.require(:mission)[:contracts_attributes].present?
  #     mission_params.to_h.deep_merge({contracts_attributes: {"0": {company_id: current_user.company_id}}})
  #   else
  #     mission_params
  #   end
  # end
end
