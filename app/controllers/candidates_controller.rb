class CandidatesController < ApplicationController
  def create
    if current_user.candidate.nil?
      @candidate = Candidate.new(candidate_params)
      @candidate.user_id = current_user.id
      @candidate.save
      @candidate.valid?
      render json: json_response(@candidate)
    end
  end

  def update
    @candidate = Candidate.find_by(user_id: current_user.id)
    @candidate.update(candidate_params)
    @candidate.valid?
    render json: json_response(@candidate)
  end

  private

  def json_response(candidate)
    {
      valid: candidate.valid?,
      id: candidate.id,
      errors: candidate.errors
    }
  end

  def candidate_params
    params.require(:candidate).permit(:linkedin_url, :phone_num, :cv)
  end
end
