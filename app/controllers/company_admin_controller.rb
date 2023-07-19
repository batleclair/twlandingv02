class CompanyAdminController < ApplicationController
  # include Pundit::Authorization
  before_action :company_admin_authenticate

  layout 'company_admin'

end
