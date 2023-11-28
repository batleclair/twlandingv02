class CompanyAdmin::OffersController < CompanyAdminController
  before_action :set_tab
  before_action :set_offer_and_selection, only: [:show, :preview]

  def index
    @contact = Contact.new
    @offers = policy_scope(Offer).order(status: :asc, created_at: :desc)
    @params = request.query_parameters
    @offer = @params[:id].present? ? Offer.find(@params[:id]) : @offers.first
    authorize @offer
    @active_regions = Offer::REGIONS.select { |region| !Offer.where(publish: true, status:['active', 'draft'], region: region).empty? }
    @active_functions = Offer::FUNCTIONS.select { |function| !Offer.where(publish: true, status:['active', 'draft'], function: function).empty? }
    apply_search_filters
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

  def set_offer_and_selection
    @offer = Offer.find_by(slug: params[:slug])
    @candidacy = Candidacy.new
    @candidates = policy_scope(Candidate).select{|c| c.user.last_employee_application&.approved_status?}
    @selected_candidates = @candidates.select{|c| c.candidacies.find_by(offer_id: @offer.id).present?}
  end

  def apply_search_filters

    @counter = params.permit(:function, :full_remote, :region, :social, :environment).values.count{|v| !v.blank?}

    unless params[:social].blank? && params[:environment].blank?
      if params[:social].blank?
        @offers = @offers.joins(:beneficiary).where.not(beneficiary: { goal: Beneficiary::GOALS[1] })
      end
      if params[:environment].blank?
        @offers = @offers.joins(:beneficiary).where.not(beneficiary: { goal: Beneficiary::GOALS[0] })
      end
    end

    case params[:frequency]
    when "1"
      @offers = @offers.where(half_days_min: 1)
      @counter +=1
    when "2"
      @offers = @offers.where(half_days_min: 1..4)
      @counter +=1
    else
    end

    case params[:duration]
    when "1"
      @offers = @offers.where(months_min: 1..4)
      @counter +=1
    when "2"
      @offers = @offers.where(months_min: 1..6)
      @counter +=1
    else
    end

    @offers = @offers.where(function: params[:function]) unless params[:function].blank?
    @offers = @offers.where(full_remote: params[:full_remote]) unless params[:full_remote].blank?
    @offers = @offers.where(region: params[:region]) unless params[:region].blank? || params[:full_remote] == "1"

    # raise
  end
end
