class CompanyUser::EmployeeApplicationsController < CompanyUserController

  def new
    @employee_application = EmployeeApplication.new
    authorize @employee_application
    @eligibility_periods = current_user.company.eligibility_periods
    if !current_user.candidate.profile_completed
      redirect_to user_profile_path
      flash[:notice] = "Merci de compléter votre profil"
    else
      render new_or_renew
    end
  end

  def create
    @employee_application = EmployeeApplication.new(employee_application_params)
    authorize @employee_application
    @employee_application.candidate_id = current_user.candidate.id
    @employee_application.status = "pending"
    if @employee_application.save(context: :self_apply)
      @employee_application.new_request_email
      redirect_to root_path
      flash[:notice] = "✔️ Votre demande est envoyée ! Elle doit maintenant être approuvée par votre entreprise "
    else
      @eligibility_periods = current_user.company.eligibility_periods
      render new_or_renew, status: :unprocessable_entity
    end
  end

  def show
    @employee_application = EmployeeApplication.find(params[:id])
    authorize @employee_application
    set_status_message
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
      # candidate.clip_to_airtable
    end
  end

  def set_status_message
    status = @employee_application.status
    status_messages = {
      pending: "n'a pas encore été validée",
      approved: "a été acceptée",
      rejected: "a été refusée",
      revoked: "a été révoquée"
    }
    @status_message = "Votre demande #{status_messages[status.to_sym]} par votre entreprise"
  end

  def new_or_renew
    current_user.never_applied? ? :new : :renew
  end
end
