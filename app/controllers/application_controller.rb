class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  # before_action :subdomain_authentication!
  before_action :enforce_subdomain, if: :user_signed_in?
  before_action :verify_whitelisting, if: :user_signed_in?
  # before_action :verify_tenant_acces, if: :user_signed_in?

  include Pundit::Authorization

  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?
  after_action :store_location

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized if Rails.env.production?

  add_breadcrumb "Accueil", "/"

  def default_url_options
    { host: ENV["DOMAIN"] || "lvh.me:3000" }
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(:email, :password, :password_confirmation, :current_password, :first_name, :last_name, candidate_attributes: [:location, :birth_date, :phone_num, :id])
    end
  end

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, candidate_attributes: [:location, :birth_date, :phone_num, :id]])
  # end

  protected

  def admin_authenticate
    authorize current_user, :admin?
  end

  def company_admin_authenticate
    authorize current_user, :company_admin?
  end

  def subdomain_authentication!
    authenticate_user! if Subdomain.new("tenant").matches?(request)
  end

  # def verify_tenant_acces
  #   if user_signed_in? && current_user.company && !current_user.whitelist
  #     sign_out_and_redirect(current_user)
  #   else
  #     user_not_authorized unless request.subdomain == current_user.subdomain || ( current_user.subdomain.blank? && Subdomain.new("generic").matches?(request) )
  #   end
  # end

  def enforce_subdomain
    if current_user.subdomain != request.subdomain
      user = current_user
      url = user.company_admin? ? admin_url(subdomain: current_user.subdomain) : root_url(subdomain: current_user.subdomain)
      redirect_to url, allow_other_host: true
      sign_in(user)
    end
  end

  def verify_whitelisting
    if current_user.company && !current_user.whitelist
      @user = current_user
      sign_out_and_redirect(current_user)
    end
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  # def after_update_path_for
  #   edit_user_registration_path
  # end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if params[:action] == "preview" # store search params for offer preview and filters.
      session["user_return_to"] = "/missions#{params[:search]}"
    elsif (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users/password" &&
        request.fullpath != "/users/sign_out" &&
        # request.fullpath != "/users/edit" &&
        !request.xhr?) # don't store ajax calls
      session["user_return_to"] = request.fullpath
    end
  end

  def log_event
    url = "https://graph.facebook.com/v15.0/#{ENV['PIXEL_ID']}/events?access_token=#{ENV['TOKEN']}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
    request.body = event_params.to_json
    http.use_ssl = true
    resp = http.request(request)
    puts(resp.body)
  end

  def user_not_authorized
    if user_signed_in? && current_user.whitelist
      if current_user.company_admin?
        redirect_to admin_url(subdomain: current_user.subdomain), allow_other_host: true
      else
        redirect_to root_url(subdomain: current_user.subdomain), allow_other_host: true
      end
    else
      redirect_to root_url
    end
    flash[:notice] = "✋ cette page n'est pas autorisée"
  end

end
