class OfferBookmarksController < ApplicationController
  def create
    @offer_bookmark = OfferBookmark.new
    @offer_bookmark.offer_list_id = params[:offer_list_id]
    @offer_bookmark.offer_id = params[:offer_bookmark][:offer_id]
    authorize @offer_bookmark
    @offer_bookmark.save
    # @offer_list = OfferList.find_by(id: params[:offer_list_id])
    @offer_bookmarks = OfferBookmark.where(offer_list_id: params[:offer_list_id])
    respond_to do |format|
      format.json { render :list }
    end
  end

  def destroy
    @offer_bookmark = OfferBookmark.find(params[:id])
    @offer_bookmarks = @offer_bookmark.offer_list.offer_bookmarks
    # @offer_list = @offer_bookmark.offer_list
    authorize @offer_bookmark
    @offer_bookmark.destroy
    respond_to do |format|
      format.json { render :list }
    end
  end
end
