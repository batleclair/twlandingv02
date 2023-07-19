class CompanyAdmin::EmployeeApplicationsController < CompanyAdminController
  def index
    @employee_applications = policy_scope(EmployeeApplication)
    authorize @employee_applications
  end

  def show
    @employee_application = EmployeeApplication.find(params[:id])
    respond_to do |format|
      format.html
      format.json
    end
  end

  def update
    @employee_application = EmployeeApplication.find(params[:id])
    @employee_application.update(employee_application_params)
    if @employee_application.save
      redirect_to admin_employee_applications_path
    end
  end

  private
  def employee_application_params
    params.require(:employee_application).permit(:status, :response_msg)
  end
end
