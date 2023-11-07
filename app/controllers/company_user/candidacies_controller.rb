# require 'airrecords/aircandidacy'
# require 'airrecords/airoffer'
# require 'airrecords/aircandidate'

class CompanyUser::CandidaciesController < CompanyUserController
  # include ControllerUtilities
  before_action :set_candidacy, except: [:index, :index_selection, :create]
  before_action :set_tab, only: [:show, :index]

  def index
    set_candidacies
  end

  def create
    @candidacy = Candidacy.new(candidacy_params)
    authorize @candidacy
    @offer = Offer.find_by(slug: params[:user_offer_slug])
    @candidacy.offer = @offer
    @candidacy.candidate = current_user.candidate
    @candidacy.origin = "company_user"
    @candidacy.active = true
    if @candidacy.save(context: :validation_step)
      # @candidacy.clip_to_airtable if @candidacy.status != "selection"
      redirect_back(fallback_location: user_offers_path)
      flash[:notice] = "Enregistré, nous informons l'association"
    else
      @tab = 1
      @selection = @candidacy
      render show_view, status: :unprocessable_entity
      flash[:alert] = "Un problème est survenu"
    end
  end

  def show
    session.delete(:selection_error)
    set_comment
    set_selected_periodicity
    render show_view
  end

  def update
    @candidacy_on_record = policy_scope(Candidacy).find(params[:id])
    @candidacy.assign_attributes(candidacy_params)
    @offer = @candidacy.offer
    assign_user_to_comment
    set_custom_periodicity
    set_active_upon_application
    if @candidacy.save(context: :validation_step)
      # @candidacy.clip_to_airtable if @candidacy.status != "selection"
      redirect_back(fallback_location: user_candidacies_path)
      flash[:notice] = "Enregistré !"
    else
      set_comment
      @tab = 1 if session[:selection_error]
      @selection = @candidacy
      render show_view, status: :unprocessable_entity
      flash[:alert] = "Veuillez vérifier les informations saisies"
      # raise
    end
  end

  private

  def set_candidacy
    @candidacy = policy_scope(Candidacy).find(params[:id])
    @candidacy_on_record = policy_scope(Candidacy).find(params[:id])
    authorize @candidacy
  end

  def set_tab
    @tab = 3
  end

  def set_selected_periodicity
    if @candidacy.req_periodicity.nil?
      @selected_periodicity = false
    elsif Candidacy::PERIODICITY.include?(@candidacy.req_periodicity)
      @selected_periodicity = @candidacy.req_periodicity
    else
      @selected_periodicity = Candidacy::PERIODICITY.last
    end
  end

  def set_candidacies
    scope = policy_scope(Candidacy).where.not(id: @active_engagement&.id).where.not(status: "selection")
    @candidacies = case params[:phase]
    when "assessing"
      scope.select{|c| c.being_assessed?}
    when "validating"
      scope.select{|c| c.being_validated? || c.validated? }
    when "abandonned"
      scope.select{|c| c.abandonned?}
    else
      scope
    end
  end

  def set_comment
    @comment = @candidacy.new_comment? ? @candidacy.comments.last : Comment.new
  end

  def candidacy_params
    params.require(:candidacy).permit(
      :status,
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

  # def full_candidacy_params
  #   if params.require(:candidacy)[:comments_attributes].present?
  #     candidacy_params.to_h.deep_merge({comments_attributes: {"0": {user_id: current_user.id}}})
  #   else
  #     candidacy_params
  #   end
  # end

  def assign_user_to_comment
    @candidacy.comments.last.user_id = current_user.id if @candidacy.new_comment?
  end

  # def render_show_view
  #   case
  #   when @candidacy.being_assessed?
  #     session[:selection_error] = "company_user/candidacies/show_assessing"
  #     render :show_assessing
  #   when @candidacy.being_validated?
  #     session[:selection_error] = "company_user/candidacies/show_validating"
  #     render :show_validating
  #   when @candidacy.abandonned?
  #     session[:selection_error] = "company_user/candidacies/show_abandonned"
  #     render :show_abandonned
  #   when @candidacy.validated?
  #     if @candidacy.mission.nil?
  #       render :show_validating
  #     else
  #       redirect_to user_mission_path(@candidacy.mission)
  #     end
  #   else
  #     return
  #   end
  # end

  def show_view
    validation_views = {
      assessing: :show_assessing,
      validating: :show_validating,
      abandonned: :show_abandonned,
      approved: :show_approved
    }
    status = @candidacy_on_record&.validation_status
    return session[:selection_error] ? "company_user/offers/show" : validation_views[status]
  end

  # def fallback_action
  #   path = session[:selection_error]
  #   if legit?(path)
  #     @offer = @candidacy.offer
  #     @selection = @candidacy
  #     render path, status: :unprocessable_entity
  #   else
  #     redirect_back(fallback_location: root_path)
  #   end
  # end

  def set_active_upon_application
    @candidacy.active = true if @candidacy.status == "user_application" && @candidacy_on_record.status == "selection"
  end

  def set_custom_periodicity
    custom_periodicity = params.require(:candidacy)[:custom_periodicity]
    if @candidacy.req_periodicity == Candidacy::PERIODICITY.last && !custom_periodicity.blank?
      @candidacy.req_periodicity = custom_periodicity
    end
  end
end
