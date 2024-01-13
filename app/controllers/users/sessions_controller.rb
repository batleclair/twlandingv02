class Users::SessionsController < Devise::SessionsController
  # skip_before_action :always_authenticate_on_subdomain!, only: %i[new, destroy]

  def new
    add_breadcrumb "Connexion", new_user_session_path
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    # if request.subdomain == resource.subdomain || (Subdomain.new('generic').matches?(request) && resource.subdomain.blank?)
    respond_with resource, location: after_sign_in_path_for(resource)
    # else
    #   redirect_to custom_after_sign_in_path_for(resource), allow_other_host: true
    #   # redirect_to root_url(subdomain: resource.company.slug), allow_other_host: true
    # end
  end

  def destroy
    @user = current_user
    super
  end

  private

  def after_sign_in_path_for(resource)
    if resource.company_admin?
      admin_path
    else
      stored_location_for(resource) || root_path
    end
  end

  def custom_after_sign_in_path_for(resource)
    resource.company_admin? ? admin_url(subdomain: resource.subdomain) : root_url(subdomain: resource.subdomain)
  end

  def after_sign_out_path_for(resource)
    @user.company ? new_user_session_path : root_path
  end
end
