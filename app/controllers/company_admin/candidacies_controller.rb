class CompanyAdmin::CandidaciesController < CompanyAdminController
before_action :set_candidacy, only: [:show, :update]

  def index
    @candidacies = policy_scope(Candidacy).where(last_active_status: ["user_validation", "admin_validation", "mission"])
  end

  def show
    set_candidacies_and_interractions
    @candidacy_on_record = Candidacy.find(params[:id])
    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @candidacy = Candidacy.new(candidacy_params)
    authorize @candidacy
    @offer = Offer.find_by(slug: params[:company_admin_offer_slug])
    @candidacy.assign_attributes(offer_id: @offer.id, origin: current_user.role, active: true)
    if @candidacy.save
      # @candidacy.clip_to_airtable
      flash[:notice] = "Suggestion enregistrée"
      redirect_back(fallback_location: company_admin_offers_path)
    else
      flash[:alert] = "Un problème est survenu"
      render 'offers/show', status: :unprocessable_entity
    end
  end

  def update
    @candidacy_on_record = Candidacy.find(params[:id])
    @candidacy.assign_attributes(full_candidacy_params)
    @candidacy.active = true if @candidacy.last_active_status == "mission" && @candidacy_on_record.last_active_status == "user_validation"
    # raise
    if @candidacy.save(context: :validation_step)
      # @candidacy.clip_to_airtable
      redirect_back(fallback_location: company_admin_candidacies_path)
      flash[:notice] = "Enregistré !"
    else
      set_candidacies_and_interractions
      flash[:alert] = "Un problème est survenu"
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_candidacy
    @candidacy = Candidacy.find(params[:id])
    authorize @candidacy
  end

  def set_candidacies_and_interractions
    @candidacies = policy_scope(Candidacy).where(last_active_status: ["user_validation", "admin_validation", "mission"])
    @comment = @candidacy.new_comment? ? @candidacy.comments.last : Comment.new
  end

  def candidacy_params
    params.require(:candidacy).permit(:offer_id,
    :candidate_id,
    :last_active_status,
    :active,
    :manager_validation,
    :admin_validation_date,
    :admin_validation_message,
    comments_attributes: [:content])
  end

  def full_candidacy_params
    if params.require(:candidacy)[:comments_attributes].present?
      candidacy_params.to_h.deep_merge({comments_attributes: {"0": {user_id: current_user.id}}})
    else
      candidacy_params
    end
  end
end
