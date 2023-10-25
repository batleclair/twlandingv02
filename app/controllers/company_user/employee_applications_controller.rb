class CompanyUser::EmployeeApplicationsController < CompanyUserController

  def new
    @employee_application = EmployeeApplication.new
    authorize @employee_application
    @eligibility_periods = current_user.company.eligibility_periods
  end

  def create
    @employee_application = EmployeeApplication.new(employee_application_params)
    authorize @employee_application
    @employee_application.candidate_id = current_user.candidate.id
    if @employee_application.save(context: :self_apply)
      redirect_to root_path
    else
      @eligibility_periods = current_user.company.eligibility_periods
      render :new, status: :unprocessable_entity
    end
  end

  private

  def employee_application_params
    params.require(:employee_application).permit(:motivation_msg, :eligibility_period_id)
  end

  def attach_candidate
    if current_user.candidate.present?
      @employee_application.candidate_id = current_user.candidate.id
    else
      candidate = Candidate.create(user_id: current_user.id)
      @employee_application.candidate = candidate
      candidate.clip_to_airtable
    end
  end
end
