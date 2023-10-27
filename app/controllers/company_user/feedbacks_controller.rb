class CompanyUser::FeedbacksController < CompanyUserController
  before_action :set_feedback_and_mission, only: [:new, :create]
  before_action :set_tab, only: [:new, :edit]


  def new
    @answer = Answer.new
  end

  def edit
    @feedback = Feedback.find(params[:id])
    @mission = @feedback.mission
    authorize @feedback
    # @answers = Answer.new
  end

  def create
    @feedback.assign_attributes(feedback_params)
    if @feedback.save
      redirect_to user_mission_confirmation_path(user_mission_id: @mission.id, step: 3)
    else
      render :new, status: :unprocessable_entity
      flash[:notice] = "marche pas"
    end
  end

  def update
    @feedback = Feedback.find(params[:id])
    @mission = @feedback.mission
    authorize @feedback
    @feedback.assign_attributes(feedback_params)
    if @feedback.save
      redirect_to user_mission_confirmation_path(user_mission_id: @mission.id, step: 3)
    else
      render :edit, status: :unprocessable_entity
      flash[:notice] = "marche pas"
    end
  end

  private

  def set_feedback_and_mission
    @feedback = Feedback.new
    @mission = Mission.find(params[:user_mission_id])
    @feedback.mission = @mission
    authorize @feedback
  end

  def set_tab
    @tab = 4
  end

  def feedback_params
    params.require(:feedback).permit(answers_attributes:[:id, :question_id, :text_answer, :boolean_answer, :integer_answer])
  end
end
