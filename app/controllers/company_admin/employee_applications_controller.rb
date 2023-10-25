# require 'airrecords/aircandidate'

class CompanyAdmin::EmployeeApplicationsController < CompanyAdminController
  def index
    @employee_applications = policy_scope(EmployeeApplication).status_as(EmployeeApplication.statuses[params[:status]])
    authorize @employee_applications
  end

  def show
    @employee_applications = policy_scope(EmployeeApplication).status_as(EmployeeApplication.statuses[params[:status]])
    @employee_application = EmployeeApplication.find(params[:id])
    render view_for(@employee_application.status)
    set_heading
    # case
    # when @employee_application.pending_status?
    #   render :show_pending
    # when @employee_application.rejected_status?
    #   render :show_rejected
    # else

    # end
    # respond_to do |format|
    #   format.html
    #   format.json
    # end
  end

  def update
    @employee_application = EmployeeApplication.find(params[:id])
    status = @employee_application.status
    @employee_application.assign_attributes(employee_application_params)
    if @employee_application.save
      # @employee_application.user.candidate.clip_to_airtable if @employee_application.approved?
      redirect_to company_admin_employee_applications_path
    else
      @employee_applications = policy_scope(EmployeeApplication).status_as(EmployeeApplication.statuses[params[:status]])
      render view_for(status)
    end
  end

  private

  def set_heading
    @heading = case
    when @employee_application.approved_status?
      "Eligibilité accordée"
    when @employee_application.pending_status?
      "Demande d'éligibilité en attente de réponse"
    when @employee_application.rejected_status?
      "Demande d'éligibilité refusée"
    when @employee_application.revoked_status?
      "Eligibilité révoquée"
    end
  end

  def employee_application_params
    params.require(:employee_application).permit(:status, :response_msg)
  end

  def view_for(status)
    case status
    when "approved"
      :show_approved
    when "pending"
      :show_pending
    when "rejected"
      :show_rejected
    when "revoked"
      :show_revoked
    else
      :index
    end
  end
end
