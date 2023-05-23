class ContactsController < ApplicationController
  skip_before_action :authenticate_user!
  invisible_captcha only: [:create], on_timestamp_spam: :custom_spam_callback

  def create
    return if daily_limit?
    @contact = Contact.new(contact_params)
    authorize @contact
    if @contact.valid?
      # && verify_recaptcha(action: 'contact', minimum_score: 0.1, secret_key: ENV['RECAPTCHA_PRIVATE_KEY'])
      log_event if @contact.save
      ContactMailer.with(contact: @contact).new_contact_email.deliver_later
    end
    render json: json_response(@contact)
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    authorize @contact
    redirect_to admin_contacts_path, status: :see_other
  end

  private

  def json_response(contact)
    {
      valid: contact.valid?,
      id: contact.id,
      errors: contact.errors
    }
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :contact_type, :organization, :message, :phone_num)
  end

  def daily_limit?
    count = Contact.where(created_at: (Time.now - 1.day)..).length
    return count > 50
  end

  def event_params
    {
      data: [
        {
          event_name: "Contact",
          event_time: Time.now.to_i,
          event_source_url: request.original_url,
          user_data: {
            client_ip_address: request.remote_ip,
            client_user_agent: request.user_agent,
            em: Digest::SHA256.hexdigest(@contact.email),
            fn: Digest::SHA256.hexdigest(@contact.first_name),
            ln: Digest::SHA256.hexdigest(@contact.last_name)
          },
          custom_data: {
            contact_type: @contact.contact_type
          }
        }
      ]
    }
  end

  def custom_spam_callback
    session[:invisible_captcha_timestamp] = 2.seconds.from_now(Time.zone.now).iso8601
    json = {
      errors: {
        captcha: ["Une erreur s'est produite, veuillez réessayer"]
      }
    }
    render json: json
  end
end
