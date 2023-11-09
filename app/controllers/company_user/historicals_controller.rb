class CompanyUser::HistoricalsController < CompanyUserController

  def index
    scope = policy_scope(Candidacy).where(active: false).where.not(status: :selection)
    @candidacies = scope.select{|s| !s.mission.present? }
    @missions = scope.select{|s| s.mission.present? }
    @tab = 6
  end
end
