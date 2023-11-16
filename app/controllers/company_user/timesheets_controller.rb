class CompanyUser::TimesheetsController < CompanyUserController
  before_action :set_missions, only: [:index, :new, :show, :edit]
  before_action :set_timesheet, only: [:show, :edit, :update, :destroy]
  before_action :set_calendar, only: [:index, :show, :edit, :new]
  before_action :set_tabs, only: [:index, :new, :show, :edit]

  def index
    @mission = Mission.find(params[:user_mission_id])
    session.delete(:proceed_with_ending)
    redirect_to user_mission_path(@mission) if !@mission.activated_status?
  end

  def new
    @mission = Mission.find(params[:user_mission_id])
    @timesheet = Timesheet.new(mission_id: @mission.id, start_time: params[:start_date])
    authorize @timesheet
  end

  def show
    session.delete(:proceed_with_ending)
    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @mission = Mission.find(params[:user_mission_id])
    @timesheet = Timesheet.new(timesheet_params)
    @timesheet.mission = @mission
    authorize @timesheet
    if @timesheet.save
      redirect_to user_mission_timesheets_path(@mission)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @timesheet.assign_attributes(timesheet_params)
    if @timesheet.save
      path = session[:proceed_with_ending].nil? ? user_mission_timesheets_path(@mission) : session[:proceed_with_ending]
      # session[:proceed_with_ending] = nil
      redirect_to path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @timesheet.destroy
      redirect_to user_mission_timesheets_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_timesheet
    @timesheet = Timesheet.find(params[:id])
    authorize @timesheet
    @mission = @timesheet.mission
  end

  def set_missions
    @missions = policy_scope(Mission)
  end

  def set_calendar
    start_date = params.fetch(:start_date, Date.today).to_date
    @timesheets = policy_scope(Timesheet).where(start_time: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end

  def set_tabs
    @tab = 4
    @sub_tab = 1
  end

  def timesheet_params
    params.require(:timesheet).permit(:start_time, :end_time, :comment)
  end
end