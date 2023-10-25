class CompanyAdmin::PagesController < CompanyAdminController
  def dashboard
    authorize :company_admin_page
  end
end
