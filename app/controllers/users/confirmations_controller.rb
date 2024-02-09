# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  before_action :redirect_to_root, only: [:new, :show], if: :user_signed_in?
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)
    if signed_in?(resource_name)
      # signed_in_root_path(resource)
      resource.company_admin? ? admin_path : root_path
    else
      new_session_path(resource_name)
    end
  end

  def redirect_to_root
    path = current_user.company_admin? ? admin_path : root_path
    redirect_to path
  end
end
