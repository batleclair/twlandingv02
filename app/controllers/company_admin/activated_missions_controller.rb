class CompanyAdmin::ActivatedMissionsController < CompanyAdminController
  before_action :set_tabs

  def index
    @missions = policy_scope(Mission).where.not(status: :draft).status_as(Mission.statuses[params[:status]])
  end

  def show
    @mission = Mission.find(params[:id])
    authorize @mission
    @view = params[:view].in?(["documents", "informations"]) ? params[:view] : "reporting"
  end

  private

  def set_tabs
    @tab = 7
    h = {"informations": 1, "documents": 2}
    @subtab = params[:view]&.to_sym.in?(h.keys) ? h[params[:view].to_sym] : 0
  end
end
