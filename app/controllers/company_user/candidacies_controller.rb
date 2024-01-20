# require 'airrecords/aircandidacy'
# require 'airrecords/airoffer'
# require 'airrecords/aircandidate'

class CompanyUser::CandidaciesController < CompanyUserController
  # include ControllerUtilities
  before_action :set_candidacy, except: [:new, :index, :create, :historicals]
  before_action :set_tab, only: [:show, :index]

  def index
    set_candidacies
  end

  def new
    @offer = Offer.find_by(slug: params[:user_offer_slug])
    candidacy = @offer.candidacies&.find_by(candidate: current_user.candidate)
    @selection = candidacy ? candidacy : Candidacy.new(offer: @offer, candidate: current_user.candidate)
    authorize @selection
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
      # respond_to do |format|
      #   format.turbo_stream { redirect_to user_candidacy_path(@candidacy) }
      #   format.html { redirect_to user_candidacy_path(@candidacy) }
      # end
      redirect_to user_candidacy_path(@candidacy)
      flash[:notice] = "Enregistré, nous informons l'association"
    else
      @tab = 1
      @selection = @candidacy
      @error = true
      render after_apply_template, status: :unprocessable_entity
      flash[:alert] = "Un problème est survenu"
    end
  end

  def show
    session.delete(:selection_error)
    set_comment
    set_selected_periodicity
    @selection = @candidacy
    render show_view
  end

  def update
    @candidacy_on_record = policy_scope(Candidacy).find(params[:id])
    @candidacy.assign_attributes(candidacy_params)
    @offer = @candidacy.offer
    assign_user_to_comment
    set_custom_periodicity
    if @candidacy.save(context: :validation_step)
      # @candidacy.clip_to_airtable if @candidacy.status != "selection"
      @candidacy.send_notification(:admin_submission) if @candidacy.submitted_for_approval?
      redirect_back(fallback_location: user_candidacies_path)
      flash[:notice] = "Enregistré !"
    else
      set_comment
      @tab = 1 if session[:selection_error]
      @error = true
      @selection = @candidacy
      @selection_on_record = @candidacy_on_record
      render after_apply_template, status: :unprocessable_entity
      flash[:alert] = "Veuillez vérifier les informations saisies"
      # raise
    end
  end

  def historicals
    @candidacies = (policy_scope(Candidacy).where(active: false)).where.not(status: [:selection, :mission])
    authorize @candidacies
    @tab = 6
  end

  private

  def set_candidacy
    @candidacy = policy_scope(Candidacy).find(params[:id])
    @candidacy_on_record = policy_scope(Candidacy).find(params[:id])
    authorize @candidacy
  end

  def set_tab
    @tab = 4
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
    scope = policy_scope(Candidacy).where.not(status: "selection").where.not(active: "false")
    scope = scope.where.not(id: @current_user.candidate.active_candidacy&.id) if @active_engagement

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

    @rejected_candidacies = policy_scope(Candidacy).where.not(status: ["selection", "mission"]).where(active: "false")
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


  def assign_user_to_comment
    @candidacy.comments.last.user_id = current_user.id if @candidacy.new_comment?
  end

  def show_view
    validation_views = {
      assessing: :show_assessing,
      validating: :show_validating,
      abandonned: :show_abandonned,
      approved: :show_approved
    }
    status = @candidacy_on_record&.validation_status
    return session[:selection_error] ? "shared/company_offers/offer_page" : validation_views[status]
  end

  def after_apply_template
    turbo_frame_request? ? :new : show_view
  end

  def set_custom_periodicity
    custom_periodicity = params.require(:candidacy)[:custom_periodicity]
    if @candidacy.req_periodicity == Candidacy::PERIODICITY.last && !custom_periodicity.blank?
      @candidacy.req_periodicity = custom_periodicity
    end
  end
end
