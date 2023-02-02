class Admin::OfferListsController < ApplicationController
  def new
    @offer_list = OfferList.new
  end

  def edit
    @offer_list = OfferList.find(params[:id])
    @offer_bookmarks = OfferBookmark.where(offer_list_id: params[:id])
    @offer_bookmark = OfferBookmark.new
  end

  def index
    @offer_lists = OfferList.all
  end
end
