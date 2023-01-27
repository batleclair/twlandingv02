class Admin::ContactsController < AdminController
  def index
    @contacts = Contact.all.order(created_at: :desc)
    authorize @contacts
  end

  def edit
    @contact = Contact.find(params[:id])
    authorize @contact
  end
end
