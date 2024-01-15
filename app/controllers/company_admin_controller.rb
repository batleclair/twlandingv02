class CompanyAdminController < ApplicationController
  # include Pundit::Authorization
  before_action :company_admin_authenticate

  layout 'company_admin'

  private

  def company_admin_authenticate
    authorize current_user, :company_admin?
  end
end
