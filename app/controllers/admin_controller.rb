class AdminController < ApplicationController
  include Pundit::Authorization
  after_action :verify_authorized

  def dashboard
    authorize :dashboard, :show?
  end
end
