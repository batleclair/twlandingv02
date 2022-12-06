class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: :create
  after_action :log_event, only: :create

  private

  def check_captcha
    return if verify_recaptcha(message: "Sûr que vous êtes pas un robot ? 🤖")

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
