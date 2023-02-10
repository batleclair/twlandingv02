class Admin::OffersController < AdminController
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
end
