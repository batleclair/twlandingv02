class AdminController < ApplicationController
  include Pundit
  after_action :verify_authorized

  def dashboard
    authorize :dashboard, :show?
  end
end
