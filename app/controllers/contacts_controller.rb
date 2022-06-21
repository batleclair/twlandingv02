class ContactsController < ApplicationController

  def create
    @contact = Contact.new(contact_params)
    @contact.save

    if @contact.save && verify_recaptcha(model: @contact)
      redirect_to root_path
      flash[:notice] = "Bien reçu ! Nous vous recontacterons rapidement 😀"
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('first_name_errors', @contact.errors[:first_name].first),
            turbo_stream.update('last_name_errors', @contact.errors[:last_name].first),
            turbo_stream.update('organization_errors', @contact.errors[:organization].first),
            turbo_stream.update('contact_type_errors', @contact.errors[:contact_type].first),
            turbo_stream.update('email_errors', @contact.errors[:email].first),
            turbo_stream.update('errors', if @contact.errors.any?
                                            "Votre saisie comporte des erreurs"
                                          end)
          ]
        end
        format.html { redirect_to root_path }
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :contact_type, :organization, :message)
  end
end
