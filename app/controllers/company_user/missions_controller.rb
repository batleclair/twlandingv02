class CompanyUser::MissionsController < CompanyUserController
  before_action :set_missions, only: [:index, :show, :new]
  before_action :set_mission, only: [:show, :edit, :update]

  def index
  end

  def edit
  end

  def show
  end

  def update
    @mission.assign_attributes(mission_params)
    if @mission.save
      redirect_to after_update_path
    end
  end

  def confirm
    @mission = Mission.find(params[:user_mission_id])
    session[:proceed_with_ending] = user_mission_confirmation_path(step: 2)
    authorize @mission
  end

  private

  def set_mission
    @mission = Mission.find(params[:id])
    authorize @mission
  end

  def set_missions
    @missions = policy_scope(Mission)
  end

  def mission_params
    params.require(:mission).permit(:termination_cause, :termination_comment, :time_confirmation, :termination_confirmation)
  end

  def after_update_path
    case params[:step].to_i
    when 1
      user_mission_confirmation_path(user_mission_id: @mission.id, step: 2)
    when 2
      @mission.feedback.present? ? edit_user_mission_feedback_path(user_mission_id: @mission.id, id:@mission.feedback.id) : new_user_mission_feedback_path(@mission)
    when 3
      user_missions_path
    else
      root_path
    end
  end
end
