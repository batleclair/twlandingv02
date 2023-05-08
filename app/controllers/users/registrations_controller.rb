class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: :create
  # after_action :log_event, only: :create
  prepend_before_action :authenticate_scope!, only: [:info]

  def new
    add_breadcrumb "Inscription", new_user_registration_path
    super
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
    if account_update_params[:password].present? || !account_update_params[:email].nil?
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

  protected

  def after_update_path_for(resource)
    flash[:notice] = "Vos informations ont bien été enregistrées"
    edit_user_registration_path
  end

  private

  def check_captcha
    return if verify_recaptcha(action: 'signup', minimum_score: 0.2, secret_key: ENV['RECAPTCHA_PRIVATE_KEY'])

    self.resource = resource_class.new sign_up_params
    resource.validate
    set_minimum_password_length

    respond_with_navigational(resource) do
      flash.discard(:recaptcha_error)
      render :new
    end
  end

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
end
