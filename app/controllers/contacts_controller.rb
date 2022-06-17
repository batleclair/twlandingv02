class ContactsController < ApplicationController

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to root_path
    else

    end
  end

  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :contact_type, :organization, :message)
  end
end
