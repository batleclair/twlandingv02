class Admin::OffersController < AdminController
  before_action :set_offer, only: %i[edit update destroy]

  def index
    @offers = Offer.includes(:beneficiary).order("beneficiaries.name asc")
    authorize @offers
  end

  def new
    @offer = Offer.new
    authorize @offer
  end

  def edit
    @offer = Offer.find_by(slug: params[:slug])
    authorize @offer
  end

  def create
    @offer = Offer.new(offer_params)
    authorize @offer
    @offer.save
    if @offer.save
      redirect_to offer_path(@offer)
    else
      render new_admin_offer_path, status: :unprocessable_entity
    end
  end

  def update
    @offer = Offer.find_by(slug: params[:slug])
    @offer.update(offer_params)
    authorize @offer
    if @offer.save
      redirect_to admin_offers_path
    else
      redirect_to edit_admin_offer_path(@offer)
    end
  end

  def destroy
    @offer = Offer.find_by(slug: params[:slug])
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
      :commitment,
      :region,
      :remote_work
    )
  end
end
