class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  include Pundit::Authorization

  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?
  after_action :store_location

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  add_breadcrumb "Accueil", :root_path

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
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

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_sign_up_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_update_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users/password" &&
        request.fullpath != "/users/sign_out" &&
        request.fullpath != "/users/edit" &&
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
    redirect_back(fallback_location: root_path)
    flash[:notice] = "✋ cette page n'est pas autorisée"
  end
end
