class CompanyAdmin::PagesController < CompanyAdminController
  def dashboard
    authorize :company_admin_page
    @tab = 0
    @pending_applications = policy_scope(EmployeeApplication).where(status: "pending")
    @pending_candidacies = policy_scope(Candidacy).where(status: "user_validation", active: true)
    @pending_missions = policy_scope(Mission).where(status: "draft")
  end

  def info
    authorize :company_admin_page
    @tab = "info"
  end

end
