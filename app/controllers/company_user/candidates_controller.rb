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
    context = source == "profile" ? :profile : :apply
    @candidate.assign_attributes(candidate_params)
    saved = @candidate.save(context: context)
    if saved
      if source == "profile"
        process_profile_completion
        redirect_to root_path
      else
        process_profile_completion if @candidate.first_completion?
        flash[:notice] = "Vos informations ont bien été enregistrées"
        render params[:source].to_sym, status: :see_other
      end
    else
      render params[:source].to_sym, status: :unprocessable_entity
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
    @candidate.save_to_airtable
    @candidate.profile_completed = true
    @candidate.save
  end
end