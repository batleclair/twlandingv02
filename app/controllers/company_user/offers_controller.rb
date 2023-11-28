class CompanyUser::OffersController < CompanyUserController
  before_action :set_tab, only: [:show, :index]
  before_action :set_offer_and_selection, only: [:show, :preview]

  def index
    @contact = Contact.new
    @offers = policy_scope(Offer).order(status: :asc, created_at: :desc)
    @params = request.query_parameters
    @offer = @params[:id].present? ? Offer.find(@params[:id]) : @offers.first
    authorize @offer
    @no_offer = Offer.find_by(title: "no_offer")
    @active_regions = Offer::REGIONS.select { |region| !Offer.where(publish: true, status:['active', 'draft'], region: region).empty? }
    @active_functions = Offer::FUNCTIONS.select { |function| !Offer.where(publish: true, status:['active', 'draft'], function: function).empty? }
    apply_search_filters
    set_candidacy
  end

  def show
    if turbo_frame_request?
      render :preview
    else
      render "shared/company_offers/offer_page"
    end
  end

  private

  def set_tab
    @tab = 1
  end

  def set_offer
    @offer = Offer.find_by(slug: params[:slug])
  end

  def set_candidacy
    @candidacy = Candidacy.new
    if !user_signed_in? || current_user.candidate.nil?
      @candidate = Candidate.new
    else
      @candidate = Candidate.find_by(user_id: current_user.id)
    end
  end

  def show_existent
    authorize @offer
    @candidacy = Candidacy.new
    if !user_signed_in? || current_user.candidate.nil?
      @candidate = Candidate.new
    else
      @candidate = Candidate.find_by(user_id: current_user.id)
    end
    add_breadcrumb "Missions", offers_path
    add_breadcrumb "#{@offer.beneficiary.name} : #{@offer.title}", offer_path(@offer)
  end

  def apply_search_filters
    unless params[:social].blank? && params[:environment].blank?
      if params[:social].blank?
        @offers = @offers.joins(:beneficiary).where.not(beneficiary: { goal: Beneficiary::GOALS[1] })
      end
      if params[:environment].blank?
        @offers = @offers.joins(:beneficiary).where.not(beneficiary: { goal: Beneficiary::GOALS[0] })
      end
    end
    @offers = @offers.where(function: params[:function]) unless params[:function].blank?
    @offers = @offers.where(full_remote: params[:full_remote]) unless params[:full_remote].blank?
    @offers = @offers.where(region: params[:region]) unless params[:region].blank? || params[:full_remote] == "1"
    @counter = params.permit(:function, :full_remote, :region, :social, :environment).values.count{|v| !v.blank?}
  end

  def set_offer_and_selection
    @offer = Offer.find_by(slug: params[:slug])
    authorize @offer
    @selection = Candidacy.find_by(offer_id: @offer.id, candidate_id: current_user.candidate.id) || Candidacy.new
    @selection_on_record = @selection
    session[:selection_error] = true
  end
end
