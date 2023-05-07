class CandidatesController < ApplicationController
  before_action :set_candidate, only: %i[show update]
  respond_to :html, :xml, :json

  def show
    authorize @candidate
    @select_offers = Offer.where(function: @candidate.function).and(Offer.where(publish: true)).limit(3)
    @applied_offers = Offer.joins(:candidacies).where(candidacies: {candidate_id: @candidate.id})
    add_breadcrumb "Mon profil", candidate_path(@candidate)
  end

  def new
    @candidate = current_user.candidate.present? ? current_user.candidate : Candidate.new
    authorize @candidate
  end

  def edit
    @candidate = current_user.candidate
    authorize @candidate
    # add_breadcrumb "Mon profil", candidate_path(@candidate)
    # add_breadcrumb "Modification du profil", edit_candidate_path(@candidate)
  end

  def skillset
    @candidate = current_user.candidate
    authorize @candidate
    @experience = Experience.new
  end

  def init
    @candidate = current_user.candidate
    authorize @candidate
  end

  def wishes
    @candidate = current_user.candidate
    authorize @candidate
  end

  def create
    @candidate = Candidate.new(candidate_params)
    authorize @candidate
    @candidate.user_id = current_user.id
    if @candidate.save
      redirect_to candidate_path(@candidate)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def synch_create
    @candidate = Candidate.new(candidate_params)
    authorize @candidate
    @candidate.user_id = current_user.id
    @candidate.save
    @candidate.valid?
    render json: json_response(@candidate)
  end

  def synch_update
    @candidate = Candidate.find_by(user_id: current_user.id)
    authorize @candidate
    @candidate.update(candidate_params)
    @candidate.valid?
    render json: json_response(@candidate)
  end

  def synch_update_min
    @candidate = Candidate.find_by(user_id: current_user.id)
    authorize @candidate
    @candidate.update(candidate_params)
    @candidate.valid?(:min_info)
    render json: json_resp_min(@candidate)
  end

  def update
    authorize @candidate
    @candidate.should_validate = true if params[:source] == "new"
    @candidate.update(candidate_params)
    if @candidate.save
      # save_to_airtable if @candidate.first_completion?
      save_to_airtable
      flash[:notice] = "Vos informations ont bien été enregistrées"
      @experience = Experience.new
      render params[:source].to_sym, status: :see_other
    else
      render params[:source].to_sym, status: :unprocessable_entity
    end
  end

  def destroy
    @candidate = Candidate.find(params[:id])
    @candidate.destroy
    authorize @candidate
    redirect_to admin_candidates_path, status: :see_other
  end

  private

  def json_response(candidate)
    {
      valid: candidate.valid?,
      id: candidate.id,
      errors: candidate.errors
    }
  end

  def json_resp_min(candidate)
    {
      valid: candidate.valid?(:min_info),
      id: candidate.id,
      errors: candidate.errors
    }
  end

  def set_candidate
    @candidate = Candidate.find(params[:id])
  end

  def candidate_params
    params.require(:candidate).permit(
      :linkedin_url,
      :phone_num,
      :cv,
      :status,
      :title,
      :location,
      :employer_name,
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
      primary_cause: [],
      secondary_cause: [],
      candidacy_attributes: [:motivation_msg]
    )
  end

  def save_to_airtable
    @table = Airrecord.table("patpv9PoowQe6o0eH.63555bec12e012fa3a019ee00390a9ab3709696e0787c857eef9e9675a4550b7", "appxT62OstSXOz8FQ", "Candidats")
    @record = @table.new(
      "Prénom": @candidate.user.first_name,
      "Nom": @candidate.user.last_name,
      "Email": @candidate.user.email,
      "Phone": @candidate.phone_num,
      "Statut": @candidate.status,
      "Profil": @candidate.description,
      "CV": Cloudinary::Utils.cloudinary_url(@candidate.cv.key),
      "Linkedin": @candidate.linkedin_url,
      "Localisation": @candidate.location,
      "Entreprise": @candidate.employer_name,
      "Compétences": [ @candidate.function ],
      "Détails": @candidate.skill_list.join(", "),
      "Bénévolat": @candidate.volunteering,
      "Dispos": @candidate.availability_output,
      "Dispo détails": @candidate.availability_details,
      "Cause": @candidate.primary_causes,
      "Télétravail": @candidate.remote_work,
      "Remarques": @candidate.comment,
      "Source": "Site"
      )
    if @record.create
      @candidate.profile_completed = true
      @candidate.save
    else
      raise
    end
  end
end
