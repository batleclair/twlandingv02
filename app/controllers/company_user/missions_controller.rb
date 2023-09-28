class CompanyUser::MissionsController < CompanyUserController
  before_action :set_missions, only: [:index, :show, :new]

  def index
  end

  def edit
    @mission = Mission.find(params[:id])
    authorize @mission
  end

  def show
    @mission = Mission.find(params[:id])
    authorize @mission
  end

  private

  def set_missions
    @missions = policy_scope(Mission)
  end

end
