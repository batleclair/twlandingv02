class Admin::MissionsController < ApplicationController

  def index
    @missions = Mission.all
  end

  def edit
    @mission = Mission.find(params[:id])
    render edit_template
  end

  def update
    @mission = Mission.find(params[:id])
    @mission.assign_attributes(mission_params)
    if @mission.save
      redirect_to admin_missions_path
    else
      render edit_template, status: :unprocessable_entity
    end
  end

  private

  def mission_params
    params.require(:mission).permit(
      :status,
      :start_date,
      :end_date,
      :periodicity,
      :days_count,
      :title,
      :description,
      :referent_name,
      :referent_email,
      :active,
      :mission_type,
      :feedback_on,
      :feedback_step,
      :feedback_unit,
      :feedback_start,
      :beneficiary_approval,
      :manager_approval,
      :employee_approval,
      :termination_cause,
      :termination_comment,
      :termination_confirmation
    )
  end

  def edit_template
    case params[:view]
    when "terms"
      :edit_terms
    when "feedbacks"
      :edit_feedbacks
    else
      :edit
    end
  end
end
