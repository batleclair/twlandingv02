class CandidatesController < ApplicationController
  def create
    if current_user.candidate.nil?
      @candidate = Candidate.new(user_id: current_user.id)
      @candidate.save
      render json: { id: @candidate.id }
    end
  end

  def update
    @candidate = Candidate.find_by(user_id: current_user.id)
    @candidate.update(candidate_params)
    render json: { valid: @candidate.valid? }
  end

  private

  def candidate_params
    params.require(:candidate).permit(:linkedin_url, :phone_num, :cv)
  end
end
