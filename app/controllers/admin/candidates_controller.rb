class Admin::CandidatesController < AdminController
  def show
    @candidate = Candidate.find(params[:id])
    authorize @candidate
  end

  def index
    @candidates = Candidate.all.order(created_at: :desc)
    authorize @candidates
  end
end
