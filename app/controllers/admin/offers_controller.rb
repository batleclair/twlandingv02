class Admin::OffersController < AdminController
  def index
    @offers = Offer.all
    authorize @offers if current_user.user_type == 'admin'
  end

  def new
    @offer = Offer.new
    authorize @offer
  end

  def edit
    @offer = Offer.find(params[:id])
    authorize @offer
  end
end