class ContactsController < ApplicationController

  def create
    @contact = Contact.new(contact_params)
    if @contact.valid? && verify_recaptcha(model: @contact, message: "Sûr que vous êtes pas un robot ? 🤖")
      @contact.save
      ContactMailer.with(contact: @contact).new_contact_email.deliver_later
      redirect_to root_path
      flash[:notice] = "Bien reçu ! Nous vous recontacterons rapidement 😀"
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: form_errors }
        format.html { redirect_to root_path }
      end
    end
  end

  private

  def form_errors
    [
      turbo_stream.update('first_name_errors', @contact.errors[:first_name].first),
      turbo_stream.update('last_name_errors', @contact.errors[:last_name].first),
      turbo_stream.update('organization_errors', @contact.errors[:organization].first),
      turbo_stream.update('contact_type_errors', @contact.errors[:contact_type].first),
      turbo_stream.update('email_errors', @contact.errors[:email].first),
      turbo_stream.update('errors', if @contact.errors.any?
                                      "Votre saisie comporte des erreurs"
                                    end),
      turbo_stream.update('robot', @contact.errors[:base].first)
    ]
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :contact_type, :organization, :message)
  end
end
