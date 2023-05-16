class Users::PasswordsController < Devise::PasswordsController
  append_before_action :assert_reset_token_passed, only: [:edit, :choose]

  def choose
    self.resource = resource_class.new
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]
  end

  def after_resetting_password_path_for(resource)
    params[:user]["created_by_admin"] ? new_candidate_path : offers_path
  end

end
