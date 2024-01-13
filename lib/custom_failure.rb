class CustomFailure < Devise::FailureApp
  def redirect_url
    if warden_message == :unconfirmed
      email = params[:user][:email] if params[:user]&[:email]
      unconfirmed_user_path(email: email)
    else
      super
    end
  end
end
