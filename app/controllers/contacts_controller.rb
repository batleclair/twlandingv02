class ContactsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @contact = Contact.new(contact_params)
    authorize @contact
    if @contact.valid? && verify_recaptcha(action: 'contact', minimum_score: 0.5, message: "test robot")
      log_event if @contact.save
      # ContactMailer.with(contact: @contact).new_contact_email.deliver_later
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
end
