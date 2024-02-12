class Users::PasswordsController < Devise::PasswordsController
  append_before_action :assert_reset_token_passed, only: [:edit, :choose]

  def choose
    self.resource = resource_class.new
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]
  end

  def after_resetting_password_path_for(resource)
    if resource_class.sign_in_after_reset_password
      params[:user]["created_by_admin"] ? new_candidate_path : after_sign_in_path_for(resource)
    else
      new_session_path(resource_name)
    end
  end

end
