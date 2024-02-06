class CompanyUser::SettingsController < CompanyUserController
  before_action :set_tab
  before_action :set_user, only: [:update_user, :update_candidate, :update_account]
  before_action :set_candidate, only: [:update_user, :update_candidate]

  def edit
    @sub_tab = 0
    @user = current_user
  end

  def profile
    @candidate = current_user.candidate
    @experiences = @candidate.experiences
    @sub_tab = 1
  end

  def account
    @sub_tab = 2
  end

  def update_user
    @user.assign_attributes(user_params)
    if @user.save(context: :profile)
      flash[:notice] = "Modifications enregistrées"
      redirect_back(fallback_location: user_settings_path)
    else
      @sub_tab = 0
      render :edit, status: :unprocessable_entity
    end
  end

  def update_candidate
    @candidate.assign_attributes(candidate_params)
    if @candidate.save(context: :profile)
      flash[:notice] = "Modifications enregistrées"
      redirect_to user_profile_settings_path
    else
      @experiences = @candidate.experiences
      @sub_tab = 1
      render :profile, status: :unprocessable_entity
    end
  end

  def update_account
    if @user.update_with_password(password_params)
      sign_in @user, bypass: true
      flash[:notice] = "🔒 Votre mot de passe a bien été modifié"
      redirect_to user_settings_path
    else
      @sub_tab = 2
      flash[:alert] = "Un problème est survenu"
      render :account, status: :unprocessable_entity
    end
  end

  private

  def set_tab
    @tab = "settings"
  end

  def set_user
    @user = User.find(current_user.id)
  end

  def set_candidate
    @candidate = @user.candidate
    authorize @candidate
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, candidate_attributes: [:phone_num, :location, :birth_date, :id, :photo])
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

  def candidate_params
    params.require(:candidate).permit(
      :linkedin_url,
      :cv,
      :title,
      :skill_list,
      :function,
      :birth_date,
      :function
    )
  end
end
