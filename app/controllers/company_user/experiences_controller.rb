class CompanyUser::ExperiencesController < CompanyUserController
  before_action :init_xp, only: [:new, :create]
  before_action :set_xp, only: [:edit, :update, :destroy]

  def index
    @experiences = policy_scope(Experience)
  end

  def new
    @turbo_form = turbo_frame_request?
  end

  def create
    @experience.assign_attributes(experience_params)
    @experience.candidate = current_user.candidate
    input_to_date
    if @experience.save
      @experiences = policy_scope(Experience)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("page", partial: "company_user/experiences/list") }
        format.html {redirect_to after_action_path}
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @turbo_form = turbo_frame_request?
  end

  def update
    @experience.assign_attributes(experience_params)
    input_to_date
    if @experience.save
      @experiences = policy_scope(Experience)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("page", partial: "company_user/experiences/list") }
        format.html {redirect_to after_action_path}
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @experience.destroy
    redirect_to user_experiences_path, status: :see_other
  end

  private

  def init_xp
    @experience = Experience.new
    authorize @experience
  end

  def set_xp
    @experience = Experience.find(params[:id])
    authorize @experience
  end

  def experience_params
    params.require(:experience).permit(:title, :employer, :start_date, :end_date)
  end

  def input_to_date
    @experience.start_date = "#{params[:experience][:start_date][3..]}/#{params[:experience][:start_date][0..1]}"
    @experience.end_date = "#{params[:experience][:end_date][3..]}/#{params[:experience][:end_date][0..1]}" unless @experience.end_date.blank?
  end

  def after_action_path
    params[:source].start_with?("/settings") ? user_profile_settings_path : user_experiences_path
  end
end
