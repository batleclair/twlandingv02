class Users::PasswordsController < Devise::PasswordsController
  def after_resetting_password_path_for(resource)
    offers_path
  end
end
