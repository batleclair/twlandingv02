class OfferListsController < ApplicationController
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
    @offer_list = OfferList.find(params[:id])
    @offer_list.update(offer_list_params)
    @offer_list.slug = @offer_list.title.parameterize
    authorize @offer_list
    @offer_list.save
    if @offer_list.save
      redirect_to edit_admin_offer_lists_path(@offer_list)
      flash[:notice] = "C'est enregistré"
    else
      flash[:notice] = "Y'a un problème"
    end
  end

  def destroy
    @offer_list = OfferList.find(params[:id])
    authorize @offer_list
    @offer_list.destroy
    redirect_to admin_offer_lists_path, status: :see_other
  end

  private

  def offer_list_params
    params.require(:offer_list).permit(:title)
  end
end
