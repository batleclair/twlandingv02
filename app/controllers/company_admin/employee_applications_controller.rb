# require 'airrecords/aircandidate'

class CompanyAdmin::EmployeeApplicationsController < CompanyAdminController
  def index
    @employee_applications = policy_scope(EmployeeApplication)
    authorize @employee_applications
  end

  def show
    @employee_applications = policy_scope(EmployeeApplication)
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
      # @employee_application.user.candidate.clip_to_airtable if @employee_application.approved?
      redirect_to company_admin_employee_applications_path
    end
  end

  private
  def employee_application_params
    params.require(:employee_application).permit(:status, :response_msg)
  end
end
