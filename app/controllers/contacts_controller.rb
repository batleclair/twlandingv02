class ContactsController < ApplicationController

  def create
    @contact = Contact.new(contact_params)
    @contact.save

    if @contact.save
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

  # def form_errors(contact) {
  #   first_name:contact.errors.full_messages_for(:first_name),
  #   email: contact.errors.full_messages_for(:email),
  #   contact.errors.full_messages_for(:email)
  # }

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :contact_type, :organization, :message)
  end
end

# first_name"
#     t.string "last_name"
#     t.string "email"
#     t.string "contact_type"
#     t.string "organization"
#     t.string "linkedin_url"
#     t.string "phone_num"
#     t.text "message"

# { render turbo_stream: turbo_stream.remove('test') }
