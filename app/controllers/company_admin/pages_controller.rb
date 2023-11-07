class CompanyAdmin::PagesController < CompanyAdminController
  def dashboard
    authorize :company_admin_page
    @tab = 0
  end
end
