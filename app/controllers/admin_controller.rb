class AdminController < ApplicationController
  include Pundit::Authorization
  # before_action :verify_admin
  before_action :admin_authenticate

  def dashboard
    authorize :dashboard, :super_admin?
  end

  # def verify_admin
  #   user_not_authorized if current_user.user_type != 'admin'
  # end
end
