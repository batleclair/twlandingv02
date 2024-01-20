class CompanyUserController < ApplicationController
  layout 'company_user'
  before_action :set_active_engagements
  before_action :company_user_authenticate

  private

  def set_active_engagements
    @active_mission = current_user.candidate&.active_mission
    @active_candidacy = current_user.candidate&.active_candidacy
    @active_engagement = current_user.candidate&.active_engagement
  end

  def company_user_authenticate
    authorize current_user, :company_user?
  end
end
