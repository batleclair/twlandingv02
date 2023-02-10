class AdminController < ApplicationController
  include Pundit::Authorization
  before_action :verify_admin

  def dashboard
    authorize :dashboard, :show?
  end

  def verify_admin
    user_not_authorized if current_user.user_type != 'admin'
  end
end
