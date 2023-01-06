class Users::SessionsController < Devise::SessionsController
  def new
    add_breadcrumb "Connexion"
    super
  end
end
