# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def new_user_email
    user = User.new(
      first_name: 'Baptiste',
      last_name: 'Clair',
      email: 'baptiste@demain.works',
      password: 'Demain'
    )
    UserMailer.new_user_email(user)
  end
end
