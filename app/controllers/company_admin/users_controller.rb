class CompanyAdmin::UsersController < CompanyAdminController
  before_action :set_tab, only: [:index, :new, :edit]

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
      set_tab
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    @user.update(user_params)
    if @user.save
      @user.whitelist&.update(custom_id: @user.custom_id)
      redirect_to company_admin_users_path
    else
      set_users
      set_tab
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

  def destroy_multiple
    @users = User.where(id: params[:destroy])
    @users.each {|user| user.whitelist&.destroy if user.destroy}
    redirect_to company_admin_users_path, status: :see_other
  end

  private

  def set_emails
    @emails = []
    current_user.company.whitelists.where(input_type: "email").each{|email| @emails << email.input_format if !email.user_attached?}
  end

  def set_users
    @users = policy_scope(User).order(last_name: :asc)
    @users = @users.search_by_name_and_email(params[:query]) if !params[:query].blank?
  end

  def set_tab
    @tab = 3
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :custom_id, candidate_attributes: [:function, :title, :linkedin_url, :status, :employer_name], employee_applications_attributes: [:status])
  end
end
