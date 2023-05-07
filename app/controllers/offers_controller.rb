class OffersController < ApplicationController
  before_action :set_offer, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: %i[index show dead preview]

  def show
    if @offer.nil?
      @offer = Offer.find_by(id: params[:slug].split('-').last.to_i)
      if @offer.nil?
        redirect_to offers_path, status: 301, alert: "👀 woops ! cette page n'existe pas"
        @offer = Offer.new
        authorize @offer
      else
        redirect_to offer_path(@offer), status: 301
        show_existent
      end
    elsif (user_signed_in? && current_user&.admin?) || @offer.public?
      show_existent
    else
      redirect_to dead_offer_path, status: 301
      authorize @offer
    end
  end

  def dead
    @offer = Offer.new
    authorize @offer
  end

  def index
    @contact = Contact.new
    @offers = policy_scope(Offer).order(:status)
    @params = request.query_parameters
    @no_offer = Offer.find_by(title: "no_offer")
    authorize @no_offer
    @offer = @params[:id].present? ? Offer.find(@params[:id]) : @offers.first
    authorize @offer

    @active_regions = Offer::REGIONS.select { |region| !Offer.where(publish: true, status:['active', 'draft'], region: region).empty? }
    @active_functions = Offer::FUNCTIONS.select { |function| !Offer.where(publish: true, status:['active', 'draft'], function: function).empty? }

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
    when "2"
      @offers = @offers.where(half_days_min: 1..4)
    else
    end

    case params[:duration]
    when "1"
      @offers = @offers.where(months_min: 1..2)
    when "2"
      @offers = @offers.where(half_days_min: 1..6)
    else
    end

    @offers = @offers.where(function: params[:function]) unless params[:function].blank?

    @offers = @offers.where(remote_work: params[:remote_work]) unless params[:remote_work].blank?

    @offers = @offers.where(region: params[:region]) unless params[:region].blank? || params[:remote_work] == "1"


    @candidacy = Candidacy.new
    if !user_signed_in? || current_user.candidate.nil?
      @candidate = Candidate.new
    else
      @candidate = Candidate.find_by(user_id: current_user.id)
    end
    add_breadcrumb "Missions", offers_path
  end

  def select
    params[:slug] == "nil" ? @offer = Offer.new : @offer = Offer.find(params[:slug])
    authorize @offer
    @candidacy = Candidacy.new
    if !user_signed_in? || current_user.candidate.nil?
      @candidate = Candidate.new
    else
      @candidate = Candidate.find_by(user_id: current_user.id)
    end
    respond_to do |format|
      format.json
    end
  end

  def preview
    @no_offer = Offer.find_by(title: "no_offer")
    authorize @no_offer
    @offer = params[:id].present? ? Offer.find(params[:id]) : Offer.last
    authorize @offer
    @candidacy = Candidacy.new
    if !user_signed_in? || current_user.candidate.nil?
      @candidate = Candidate.new
    else
      @candidate = Candidate.find_by(user_id: current_user.id)
    end
    respond_to do |format|
      format.json
    end
  end

  def create
    @offer = Offer.new(offer_params)
    authorize @offer
    @offer.save
    # @offer.beneficiary_id = params[:beneficiary_id]
    if @offer.save
      redirect_to offer_path(@offer)
    else
      render new_admin_offer_path, status: :unprocessable_entity
    end
  end

  def update
    @offer.update(offer_params)
    authorize @offer
    if @offer.save
      redirect_to admin_offers_path
    else
      redirect_to edit_admin_offer_path(@offer)
    end
  end

  def destroy
    authorize @offer
    @offer.destroy
    redirect_to admin_offers_path, status: :see_other
  end

  private

  def set_offer
    @offer = Offer.find_by(slug: params[:slug])
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

  def offer_params
    params.require(:offer).permit(
      :title,
      :location,
      :half_days_min,
      :half_days_max,
      :months_min,
      :months_max,
      :monthly_gross_salary,
      :description,
      :summary,
      :status,
      :publish,
      :beneficiary_id,
      :offer_type,
      :function,
      :slug,
      :commitment,
      :region,
      :remote_work
    )
  end
end
