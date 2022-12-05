class OffersController < ApplicationController
  before_action :set_offer, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: %i[index show]

  def show
    authorize @offer
    @candidacy = Candidacy.new
    if !user_signed_in? || current_user.candidate.nil?
      @candidate = Candidate.new
    else
      @candidate = Candidate.find_by(user_id: current_user.id)
    end
  end

  def index
    @contact = Contact.new
    @offers = policy_scope(Offer).order(:status)

    unless params[:social].blank? && params[:environment].blank?
      if params[:social].blank?
        @offers = @offers.joins(:beneficiary).where.not(beneficiary: { goal: Beneficiary::GOALS[0] })
      end
      if params[:environment].blank?
        @offers = @offers.joins(:beneficiary).where.not(beneficiary: { goal: Beneficiary::GOALS[1] })
      end
    end

    unless params[:low].blank? && params[:mid].blank? && params[:high].blank?
      if params[:low].blank?
        @offers = @offers.where.not(commitment: Offer::COMMITMENTS[0])
      end
      if params[:mid].blank?
        @offers = @offers.where.not(commitment: Offer::COMMITMENTS[1])
      end
      if params[:high].blank?
        @offers = @offers.where.not(commitment: Offer::COMMITMENTS[2])
      end
    end

    @offers = @offers.where(function: params[:function]) unless params[:function].blank?

    @candidacy = Candidacy.new
    if !user_signed_in? || current_user.candidate.nil?
      @candidate = Candidate.new
    else
      @candidate = Candidate.find_by(user_id: current_user.id)
    end
    @no_offer = Offer.find_by(title: "no_offer")
    authorize @no_offer
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
      :commitment
    )
  end
end
