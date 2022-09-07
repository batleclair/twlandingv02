class Admin::CandidaciesController < AdminController
  def index
    @candidacies = Candidacy.all
    authorize @candidacies
  end

  def show
    @candidacy = Candidacy.find(params[:id])
    authorize @candidacy
  end
end
