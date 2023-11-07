class CompanyAdmin::CandidaciesController < CompanyAdminController
before_action :set_candidacy, only: [:show, :update]
before_action :set_tab, only: [:index, :show]

  def index
    set_candidacies
  end

  def show
    set_comment
    render_show_view
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
      @tab = 1
      render 'offers/show', status: :unprocessable_entity
    end
  end

  def update
    @candidacy.assign_attributes(candidacy_params)
    assign_user_to_comment
    @candidacy.active = true if @candidacy.status == "mission" && @candidacy_on_record.status == "user_validation"
    if @candidacy.save(context: :validation_step)
      # @candidacy.clip_to_airtable
      @candidacy.validated? ? redirect_to(new_company_admin_candidacy_mission_path(@candidacy)) : redirect_back(fallback_location: company_admin_candidacies_path)
      flash[:notice] = "Enregistré !"
    else
      set_comment
      set_tab
      flash[:alert] = "Un problème est survenu"
      render_show_view
    end
  end

  private

  def set_candidacy
    @candidacy = Candidacy.find(params[:id])
    authorize @candidacy
    @candidacy_on_record = Candidacy.find(params[:id])
  end

  def set_candidacies
    case params[:status]
    when "pending"
      @candidacies = policy_scope(Candidacy).where(status: "user_validation").select{|c| c.submitted_for_approval?}
    when "rejected"
      @candidacies = policy_scope(Candidacy).where(status: "admin_validation").select{|c| c.abandonned?}
    when "approved"
      @candidacies = policy_scope(Candidacy).where(status: "mission").select{|c| c.validated?}
    else
      @candidacies = policy_scope(Candidacy).where(status: ["user_validation", "admin_validation", "mission"])
    end
  end

  def set_comment
    @comment = @candidacy.new_comment? ? @candidacy.comments.last : Comment.new
  end

  def set_tab
    @tab = 4
  end

  def assign_user_to_comment
    @candidacy.comments.last.user_id = current_user.id if @candidacy.new_comment?
  end

  def render_show_view
    case
    when @candidacy_on_record.submitted_for_approval?
      render :show_pending
    when @candidacy_on_record.abandonned?
      render :show_rejected
    when @candidacy_on_record.validated?
      @path = @candidacy.mission.nil? ? new_company_admin_candidacy_mission_path(@candidacy) : company_admin_mission_path(@candidacy.mission)
      render :show_approved
    else
      redirect_to company_admin_candidacies_path
    end
  end

  def candidacy_params
    params.require(:candidacy).permit(:offer_id,
    :candidate_id,
    :status,
    :active,
    :manager_validation,
    :admin_validation_date,
    :admin_validation_message,
    comments_attributes: [:content])
  end

  # def full_candidacy_params
  #   if params.require(:candidacy)[:comments_attributes].present?
  #     candidacy_params.to_h.deep_merge({comments_attributes: {"0": {user_id: current_user.id}}})
  #   else
  #     candidacy_params
  #   end
  # end
end
