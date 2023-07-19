class CompanyAdmin::PagesController < CompanyAdminController

  def dashboard
    authorize :dashboard, :company_admin?
  end
end
