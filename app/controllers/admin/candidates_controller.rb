class Admin::CandidatesController < AdminController
  def show
    @candidate = Candidate.find(params[:id])
    authorize @candidate
  end

  def index
    @candidates = Candidate.all.order(created_at: :desc)
    authorize @candidates
  end

  def destroy
    @candidate = Candidate.find(params[:id])
    @candidate.destroy
    if @candidate.destroy
      redirect_to admin_candidates_path, status: :see_other
    end
  end
end
