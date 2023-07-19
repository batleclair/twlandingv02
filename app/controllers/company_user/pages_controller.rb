class CompanyUser::PagesController < CompanyUserController
  def dashboard
    authorize :dashboard, :company_user?
  end
end
