class CompanyAdmin::UsersController < CompanyAdminController

  def index
    @users = policy_scope(User)
    authorize @users
  end

  def new
    @user = User.new
    authorize @user
    @candidate = Candidate.new
    @employee_application = EmployeeApplication.new
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    password = Devise.friendly_token
    @user.password = "demain123"
    @user.password_confirmation = "demain123"
    @user.company = current_user.company
    if @user.save
      redirect_to company_admin_users_path
    else
      @candidate = Candidate.new
      @employee_application = EmployeeApplication.new
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    @user.update(user_params)
    @user.candidate.admin_bypass_validation = true if @user.candidate.present?
    if @user.save
      redirect_to company_admin_users_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    if @user.destroy
      redirect_to company_admin_users_path, status: :see_other
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :company_role, candidate_attributes: [:function, :title, :linkedin_url, :status, :employer_name], employee_applications_attributes: [:status])
  end
end
