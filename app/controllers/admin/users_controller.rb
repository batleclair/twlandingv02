class Admin::UsersController < AdminController
  def new
    @user = User.new
    authorize @user
    set_company_list
  end

  def create
    @user = User.new(user_params)
    authorize @user
    password = Devise.friendly_token
    @user.password = password
    @user.password_confirmation = password
    if @user.save
      @token = password_invite_token
      @user.send_invite_email(@token)
      redirect_to admin_users_path
    else
      set_company_list
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @users = User.all.order(created_at: :desc)
    authorize @users
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    if @user.destroy
      redirect_to admin_users_path, status: :see_other
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :company_id)
  end

  def password_invite_token
    raw, enc = Devise.token_generator.generate(User, :reset_password_token)
    @user.reset_password_token   = enc
    @user.reset_password_sent_at = Time.now.utc
    @user.save(validate: false)
    raw
  end

  def set_company_list
    @companies = []
    Company.all.each { |company| @companies << [company.id, company.name] }
    return @companies
  end
end
