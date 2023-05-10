class Admin::UsersController < AdminController
  def index
    @users = User.all
    authorize @users
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    if @user.destroy
      redirect_to admin_users_path, status: :see_other
    end
  end
end
