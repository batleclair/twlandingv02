class CompanyUser::MissionsController < CompanyUserController
  before_action :set_missions, only: [:index, :show, :new]
  before_action :set_mission, only: [:show, :edit, :update]
  before_action :set_tab, only: [:show, :index, :confirm, :terminated]

  def index
  end

  def edit
  end

  def show
    @sub_tab = 0
    render show_view
  end

  def update
    @mission.assign_attributes(mission_params)
    if @mission.save
      redirect_to after_update_path
    else
      set_tab
      @sub_tab = 2
      render :confirm, status: :unprocessable_entity
    end
  end

  def confirm
    @sub_tab = 2
    @mission = policy_scope(Mission).find(params[:user_mission_id])
    session[:proceed_with_ending] = user_mission_confirmation_path(step: 2)
    authorize @mission
    redirect_to user_mission_path(@mission) if !@mission.activated_status?
  end

  def terminated
    @mission = policy_scope(Mission).find(params[:user_mission_id])
    authorize @mission
  end

  def historicals
    @missions = policy_scope(Mission).where(status: :terminated)
    authorize @missions
    @tab = 7
  end

  private

  def set_mission
    @mission = policy_scope(Mission).find(params[:id])
    authorize @mission
  end

  def set_missions
    @missions = policy_scope(Mission)
  end

  def set_tab
    @tab = 5
  end

  def mission_params
    params.require(:mission).permit(:termination_cause, :termination_comment, :time_confirmation, :termination_confirmation, :status)
  end

  def after_update_path
    case params[:step].to_i
    when 1
      user_mission_confirmation_path(user_mission_id: @mission.id, step: 2)
    when 2
      @mission.feedback.present? ? edit_user_mission_feedback_path(user_mission_id: @mission.id, id:@mission.feedback.id) : new_user_mission_feedback_path(@mission)
    when 3
      user_mission_path(@mission)
    else
      root_path
    end
  end

  def show_view
    "show_#{@mission.status}".to_s
  end
end
