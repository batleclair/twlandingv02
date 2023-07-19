class CompanyUser::EmployeeApplicationsController < CompanyUserController

  def new
    @employee_application = EmployeeApplication.new
    authorize @employee_application
  end

  def create
    @employee_application = EmployeeApplication.new(employee_application_params)
    authorize @employee_application
    @employee_application.user_id = current_user.id
    if @employee_application.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def employee_application_params
    params.require(:employee_application).permit(:motivation_msg)
  end
end
