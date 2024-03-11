class BookmarksController < ApplicationController
  def index
    @bookmarks = policy_scope(Candidacy)
  end

  def show
    @bookmark = Candidacy.find(params[:id])
    authorize @bookmark
  end

  def destroy

  end
end
