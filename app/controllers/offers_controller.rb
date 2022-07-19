class OffersController < ApplicationController
  before_action :set_offer, only: %i[show edit update destroy]

  def show
    @candidacy = Candidacy.new
    if current_user.candidate.nil?
      @candidate = Candidate.new
    else
      @candidate = Candidate.find_by(user_id: current_user.id)
    end
  end

  def create
    @offer = Offer.new(offer_params)
    @offer.beneficiary_id = params[:beneficiary_id]
    if @offer.save
      redirect_to offer_path(@offer)
    else

    end
  end

  def edit
  end

  def update
    @offer.update(offer_params)
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
    params.require(:offer).permit(:title, :location, :half_days_min, :half_days_max, :months_min, :months_max, :monthly_gross_salary, :description)
  end

end
