class Api::V1::InvitationsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  acts_as_token_authentication_handler_for User

  def create
    p invitation_params
    @invitation = Invitation.new
    authorize @invitation
    @invitation.assign_attributes(invitation_params)
    if @invitation.save
      render :show
    else
      render_error
    end
  end

  private

  def render_error
    render json: {
      email: @invitation.email,
      errors: @invitation.errors.full_messages
    }, status: :unprocessable_entity
  end

  def invitation_params
    params.require(:invitation).permit(
      :email,
      :first_name,
      :last_name,
      :linkedin_url,
      :phone_num,
      :location,
      :status,
      :employer_name,
      :title,
      :description,
      :function,
      :availability,
      :volunteering,
      :comment,
      :profile_completed,
      :airtable_id,
      :availability_details,
      skill_list: [],
      primary_cause: []
      )
  end
end
