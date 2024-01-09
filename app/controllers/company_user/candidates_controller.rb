class CompanyUser::CandidatesController < CompanyUserController
before_action :set_candidate

  def profile
    @candidate_on_record = @candidate
    authorize @candidate
    render current_step
  end

  def set_user
    authorize current_user
    current_user.assign_attributes(user_params)
    current_user.candidate.profile_completed = false
    if current_user.save(context: :profile)
      redirect_to user_profile_path(step: 2)
    else
      render :step_1, status: :unprocessable_entity
    end
  end

  def update
    authorize @candidate
    @candidate_on_record = @candidate
    @candidate.assign_attributes(candidate_params)
    @candidate.mode = params[:mode]
    if @candidate.save(context: :profile)
      process_profile_completion if params[:step] == '4'
      redirect_to next_step_path
    else
      render current_step, status: :unprocessable_entity
    end
  end

  private

  def set_candidate
    @candidate = current_user.candidate
  end

  def candidate_params
    params.require(:candidate).permit(
      :linkedin_url,
      :phone_num,
      :cv,
      # :status,
      :title,
      :location,
      # :employer_name,
      :photo,
      :description,
      :skill_list,
      :function,
      :birth_date,
      :past_employer_list,
      :volunteering,
      :availability,
      :availability_details,
      :remote_work,
      :comment,
      :volunteering_aknowledged,
      primary_cause: [],
      secondary_cause: [],
      candidacy_attributes: [:motivation_msg]
    )
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, candidate_attributes: [:phone_num, :location, :birth_date, :id])
  end

  def process_profile_completion
    if @candidate.first_user_completion?
      # @candidate.save_to_airtable
      @candidate.profile_completed = true
      @candidate.save
      flash[:notice] = "👏 votre profil est complété !"
    end
  end

  def current_step
    step = {'1': :step_1, '2': :step_2, '3': :step_3, '4': :step_4 }
    params[:step].present? ? step[:"#{params[:step]}"] : step[:'1']
  end

  def next_step_path
    if @candidate.mode == 'manual'
      user_experiences_path
    else
      post_profile = current_user.eligibility ? root_path : new_user_employee_application_path
      next_step = {'2': user_profile_path(step: 3), '3': user_profile_path(step: 4), '4': post_profile }
      params[:step].present? ? next_step[:"#{params[:step]}"] : root_path
    end
  end
end
