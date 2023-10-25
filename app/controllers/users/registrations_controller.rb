class Users::RegistrationsController < Devise::RegistrationsController
  # prepend_before_action :check_captcha, only: :create
  # after_action :log_event, only: :create
  prepend_before_action :authenticate_scope!, only: [:info, :edit]
  invisible_captcha only: [:create], on_timestamp_spam: :custom_spam_callback


  def new
    add_breadcrumb "Inscription", new_user_registration_path
    super
  end

  def create
    build_resource(sign_up_params)
    resource.attach_company(request)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
    # resource.send_welcome_mail if resource.persisted?
  end

  def edit
    add_breadcrumb "Mon compte", edit_user_registration_path
    self.resource = resource_class.new(sign_up_params)
    super
  end

  def info
  end

  def update
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    # if account_update_params[:password].present? || !account_update_params[:email].nil?
    if params[:source] == "edit"
      super
    else
      @user = current_user
      if @user.update(account_update_params)
        flash[:notice] = "Vos informations ont bien été enregistrées"
        render :info, status: 500
      else
        render :info, status: 422
      end
    end
  end

  def update_resource(resource, params)
    if resource.provider == 'google_oauth2'
      params.delete('current_password')
      resource.password = params['password']
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  protected

  def after_sign_up_path_for(resource)
    if stored_location_for(resource).include?("missions")
      stored_location_for(resource) || new_candidate_path
    else
      Subdomain.new("tenant").matches?(request) ? root_path : new_candidate_path
    end
  end

  def after_update_path_for(resource)
    flash[:notice] = "Vos informations ont bien été enregistrées"
    edit_user_registration_path || root_path
  end

  private

  # def check_captcha
  #   return if verify_recaptcha(action: 'signup', minimum_score: 0.5, secret_key: ENV['RECAPTCHA_PRIVATE_KEY'])

  #   self.resource = resource_class.new sign_up_params
  #   resource.validate
  #   set_minimum_password_length

  #   respond_with_navigational(resource) do
  #     flash.discard(:recaptcha_error)
  #     render :new
  #   end
  # end

  def event_params
    {
      data: [
        {
          event_name: "CompleteRegistration",
          event_time: Time.now.to_i,
          event_source_url: request.original_url,
          user_data: {
            client_ip_address: request.remote_ip,
            client_user_agent: request.user_agent,
            em: Digest::SHA256.hexdigest(@user.email),
            fn: Digest::SHA256.hexdigest(@user.first_name),
            ln: Digest::SHA256.hexdigest(@user.last_name)
          }
        }
      ]
    }
  end

  def daily_limit?
    count = User.where(created_at: (Time.now - 1.day)..).length
    return count > 50
  end

  def custom_spam_callback
    session[:invisible_captcha_timestamp] = 5.seconds.from_now(Time.zone.now).iso8601
  end
end
