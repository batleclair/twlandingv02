class CompanyAdmin::MissionsController < CompanyAdminController
before_action :set_missions
before_action :set_tab
before_action :set_mission, only: [:show]
before_action :redirect_if_active, only: [:checklist, :terms, :counterparts, :documents]

  def index
  end

  def show
    if @mission.draft_status?
      @contract = Contract.new
      step = params[:step]&.to_sym || @mission.draft_step.to_sym
      session[:mission_error] = step
      set_subtab
      render step
    else
      redirect_to company_admin_activated_mission_path(@mission, view: "informations")
    end
  end

  def create
    @mission = Mission.new(mission_params)
    @candidacy = Candidacy.find(params[:company_admin_candidacy_id])
    @mission.candidacy = @candidacy
    if @mission.save
      Comment.create(status: "mission", commentable_type: "Candidacy", user_id: current_user.id, commentable_id: @mission.candidacy.id, content: "Votre candidature a été approuvée")
      @candidacy.update(status: "mission")
      redirect_to company_admin_mission_path(@mission)
    else
      set_tab
      set_missions
      set_comment
      @candidacy_on_record = Candidacy.find(params[:company_admin_candidacy_id])
      @create_error = true
      render "company_admin/candidacies/show_pending", status: :unprocessable_entity
    end
  end

  def update
    @mission = Mission.find(params[:id])
    @candidacy = @mission.candidacy
    @mission.assign_attributes(mission_params)
    assign_company_to_contract
    if @mission.save && candidate_update
      redirect_to company_admin_mission_path(@mission, step: @mission.draft_step)
    else
      set_tab
      @error = true
      @mission_on_record = Mission.find(params[:id])
      render session[:mission_error].to_sym, status: :unprocessable_entity
    end
  end

  private

  def set_missions
    @missions = policy_scope(Mission).beneficiary_status_as(Mission.beneficiary_approvals[params[:status]])
  end

  def set_tab
    @tab = 6
  end

  def set_comment
    @comment = @candidacy.new_comment? ? @candidacy.comments.last : Comment.new
  end

  def set_subtab
    subtabs = {checklist: 3, counterparts: 0, terms: 1, documents: 2}
    view = session[:mission_error].to_sym
    @steptab = subtabs[view]
  end

  def set_mission
    @mission = Mission.find(params[:id])
    authorize @mission
    @mission_on_record = Mission.find(params[:id])
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
      :draft_step,
      contracts_attributes: [:title, :contract_type, :document]
    )
  end

  def assign_company_to_contract
    @mission.contracts.last.company_id = current_user.company_id if @mission.new_contract?
  end

  def candidate_update
    if params[:candidate].present?
      @candidate = @mission.candidate
      @candidate.update(params.require(:candidate).permit(:referent_name, :referent_email))
    else
      true
    end
  end
end
