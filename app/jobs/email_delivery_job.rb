class EmailDeliveryJob < ApplicationJob
  queue_as :default

  def perform(email)
    address = email[:to][0][:email]
    resource = User.find_by(email: address) ? User.find_by(email: address) : Whitelist.find_by(input_format: address)
    company = resource&.company
    if company&.demo_status? # || address =~ /\A[^@\s]+@[^@\s]+-demain.works\z/
      # block transactional emails in demo
      puts "no notification sent"
    else
      # send email through Brevo API
      api_instance = SibApiV3Sdk::TransactionalEmailsApi.new
      begin
        result = api_instance.send_transac_email(email)
        p result
      rescue SibApiV3Sdk::ApiError => e
        puts "Exception when calling TransactionalEmailsApi->send_transac_email: #{e}"
      end
    end
  end
end
