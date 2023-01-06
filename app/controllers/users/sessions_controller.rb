class Users::SessionsController < Devise::SessionsController
  def new
    add_breadcrumb "Connexion", new_user_session_path
    super
  end
end
