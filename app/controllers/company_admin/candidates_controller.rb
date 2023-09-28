class CompanyAdmin::CandidatesController < ApplicationController

  def update
    @candidate = Candidate.find(params[:id])
    authorize @candidate
    @candidate.update(candidate_params)
    @mission = Mission.find(params[:mission])
    if @candidate.save
      redirect_back(fallback_location: company_admin_mission_path(@mission))
    else
      redirect_to company_admin_mission_path(@mission), status: :unprocessable_entity
    end
  end

  private

  def candidate_params
    params.require(:candidate).permit(:referent_name, :referent_email)
  end
end
