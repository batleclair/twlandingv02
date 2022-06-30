# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview
  def new_contact_email
    contact = Contact.new(
      first_name: 'Baptiste',
      last_name: 'Clair',
      email: 'baptiste@demain.works',
      organization: 'Demain',
      contact_type: 'Salarié',
      message: 'lorem ipsum dolor sit amet, consectetur adipiscing elit. fusce posuere tempor dapibus'
    )
    ContactMailer.with(contact: contact).new_contact_email
  end
end
