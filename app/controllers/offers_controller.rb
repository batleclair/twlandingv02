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
    @offers = policy_scope(Offer).order(:status)
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
    params[:id] == "nil" ? @offer = Offer.new : @offer = Offer.find(params[:id])
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
    @offer.beneficiary_id = params[:beneficiary_id]
    if @offer.save
      redirect_to offer_path(@offer)
    else

    end
  end

  def edit
    authorize @offer
  end

  def update
    @offer.update(offer_params)
    authorize @offer
    if @offer.save
      redirect_to offer_path(@offer)
    else

    end
  end

  def destroy
    @offer.destroy
    redirect_to beneficiary_path(@offer.beneficiary), status: :see_other
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:title, :location, :half_days_min, :half_days_max, :months_min, :months_max, :monthly_gross_salary, :description, :status)
  end
end
