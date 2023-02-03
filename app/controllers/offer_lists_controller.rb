class OfferListsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  before_action :set_offer_list, only: [:update, :destroy]

  def show
    @offer_list = OfferList.find_by(slug: params[:slug])
    authorize @offer_list
    @no_offer = Offer.find_by(title: "no_offer")
    @candidacy = Candidacy.new
    if !user_signed_in? || current_user.candidate.nil?
      @candidate = Candidate.new
    else
      @candidate = Candidate.find_by(user_id: current_user.id)
    end
    @offers = @offer_list.offers
  end

  def create
    @offer_list = OfferList.new(offer_list_params)
    @offer_list.slug = @offer_list.title.parameterize
    authorize @offer_list
    @offer_list.save
    if @offer_list.save
      redirect_to edit_admin_offer_list_path(@offer_list, @offer_list.offer_bookmarks)
    else
      render new_admin_offer_list_path, status: :unprocessable_entity
    end
  end

  def update
    @offer_list.update(offer_list_params)
    @offer_list.slug = @offer_list.title.parameterize
    authorize @offer_list
    @offer_list.save
    if @offer_list.save
      redirect_to edit_admin_offer_list_path(@offer_list)
      flash[:notice] = "C'est enregistré"
    else
      flash[:notice] = "Y'a un problème"
    end
  end

  def destroy
    authorize @offer_list
    @offer_list.destroy
    redirect_to admin_offer_lists_path, status: :see_other
  end

  private

  def set_offer_list
    @offer_list = OfferList.find(params[:id])
  end

  def offer_list_params
    params.require(:offer_list).permit(:title, :description)
  end
end
