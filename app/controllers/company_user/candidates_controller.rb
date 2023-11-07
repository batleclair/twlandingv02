class CompanyUser::CandidatesController < CompanyUserController
before_action :set_candidate

  def profile
    @candidate_on_record = @candidate
    authorize @candidate
  end

  def update
    authorize @candidate
    @candidate_on_record = @candidate
    source = params[:source]
    @candidate.assign_attributes(candidate_params)
    @candidate.status = "Salarié·e"
    @candidate.employer_name = @candidate.user.company.name
    if @candidate.save(context: :profile)
        process_profile_completion
        redirect_to root_path
    else
      render :profile, status: :unprocessable_entity
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

  def process_profile_completion
    # @candidate.save_to_airtable
    @candidate.profile_completed = true
    @candidate.save(context: :profile)
  end
end
