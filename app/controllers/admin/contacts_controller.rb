class Admin::ContactsController < AdminController
  def index
    @contacts = Contact.all
    authorize @contacts
  end

  def edit
    @contact = Contact.find(params[:id])
    authorize @contact
  end
end
