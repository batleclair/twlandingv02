class CompanyAdmin::UsersController < CompanyAdminController

  def index
    set_users
  end

  def new
    @user = User.new
    authorize @user
    @candidate = Candidate.new
    @employee_application = EmployeeApplication.new
    set_emails
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    @user.company_role = "user"
    @user.company = current_user.company
    @user.set_temp_password
    if @user.save
      @token = @user.password_invite_token
      @user.send_invite_email(@token)
      redirect_to company_admin_users_path
    else
      @candidate = Candidate.new
      @employee_application = EmployeeApplication.new
      set_emails
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    @user.update(user_params)
    # @user.candidate.admin_bypass_validation = true if @user.candidate.present?
    if @user.save
      @user.whitelist&.update(input_custom: @user.custom_input)
      redirect_to company_admin_users_path
    else
      set_users
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    if @user.destroy
      @user.whitelist&.destroy
      redirect_to company_admin_users_path, status: :see_other
    end
  end

  private

  def set_emails
    @emails = []
    current_user.company.whitelists.where(input_type: "email").each{|email| @emails << email.input_format if !email.user_attached?}
  end

  def set_users
    @users = policy_scope(User).order(created_at: :desc)
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :custom_input, candidate_attributes: [:function, :title, :linkedin_url, :status, :employer_name], employee_applications_attributes: [:status])
  end
end
