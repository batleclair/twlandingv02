class CompanyUserController < ApplicationController
  layout 'company_user'
  before_action :set_active_engagements

  private

  def set_active_engagements
    @active_mission = current_user.candidate&.active_mission
    @active_candidacy = current_user.candidate&.active_candidacy
    @active_engagement = current_user.candidate&.active_engagement
  end
end
