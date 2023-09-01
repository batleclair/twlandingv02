class CompanyAdmin::MissionsController < CompanyAdminController

  def new
    @candidacy = Candidacy.find(params[:company_admin_candidacy_id])
    @mission = Mission.new(candidacy: @candidacy)
    authorize @mission
  end

  def create
    raise
  end

  private

  def mission_params
    params.require(:mission).permit()
  end
end
