# require 'airrecords/aircandidacy'
# require 'airrecords/airoffer'
# require 'airrecords/aircandidate'

class CompanyUser::CandidaciesController < CompanyUserController
  before_action :set_candidacy, except: [:index, :index_selection, :create]
  def index
    @candidacies = policy_scope(Candidacy).where.not(last_active_status: "selection")
  end

  def index_selection
    @candidacies = policy_scope(Candidacy)
    authorize @candidacies
  end

  def show_selection
    @candidacy_on_record = Candidacy.find(params[:id])
    @candidacies = policy_scope(Candidacy)
    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @candidacy = Candidacy.new(candidacy_params)
    authorize @candidacy
    @offer = Offer.find_by(slug: params[:user_offer_slug])
    @candidacy.offer = @offer
    @candidacy.candidate = current_user.candidate
    @candidacy.origin = current_user.role
    @candidacy.active = true
    if @candidacy.save
      # @candidacy.clip_to_airtable if @candidacy.last_active_status != "selection"
      redirect_back(fallback_location: user_offers_path)
      flash[:notice] = "Enregistré, nous informons l'association"
    else
      redirect_back(fallback_location: user_offers_path)
      flash[:alert] = "Un problème est survenu"
    end
  end

  def show
    @candidacy_on_record = Candidacy.find(params[:id])
    set_candidacies_and_interractions
    respond_to do |format|
      format.html
      format.json
    end
  end

  def update
    @candidacy_on_record = Candidacy.find(params[:id])
    @candidacy.assign_attributes(full_candidacy_params)
    set_custom_periodicity
    set_active_upon_application
    if @candidacy.save(context: :validation_step)
      # @candidacy.clip_to_airtable if @candidacy.last_active_status != "selection"
      redirect_back(fallback_location: user_candidacies_path)
      flash[:notice] = "Enregistré !"
    else
      set_candidacies_and_interractions
      flash[:alert] = "Veuillez vérifier les informations saisies"
      render params.require(:candidacy)[:source].to_sym, status: :unprocessable_entity
    end
  end

  private

  def set_candidacy
    @candidacy = Candidacy.find(params[:id])
    authorize @candidacy
  end

  def candidacy_params
    params.require(:candidacy).permit(
      :last_active_status,
      :active,
      :motivation_msg,
      :req_start_date,
      :req_periodicity,
      :req_days,
      :req_description,
      :user_validation_date,
      :user_validation_message,
      comments_attributes: [:content])
  end

  def full_candidacy_params
    if params.require(:candidacy)[:comments_attributes].present?
      candidacy_params.to_h.deep_merge({comments_attributes: {"0": {user_id: current_user.id}}})
    else
      candidacy_params
    end
  end

  def set_candidacies_and_interractions
    @candidacies = policy_scope(Candidacy)
    @comment = @candidacy.new_comment? ? @candidacy.comments.last : Comment.new
    # @aircandidate = Aircandidate.find(@candidacy.candidate.airtable_id)
    # @interractions = @aircandidate.aircandidacies.select {|a| a["Offres"] == [@candidacy.offer.airtable_id] }
  end

  def set_active_upon_application
    @candidacy.active = true if @candidacy.last_active_status == "user_application" && @candidacy_on_record.last_active_status == "selection"
  end

  def set_custom_periodicity
    custom_periodicity = params.require(:candidacy)[:custom_periodicity]
    if @candidacy.req_periodicity == Candidacy::PERIODICITY.last && !custom_periodicity.blank?
      @candidacy.req_periodicity = custom_periodicity
    end
  end
end
