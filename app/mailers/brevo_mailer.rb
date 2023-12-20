class BrevoMailer < ActionMailer::Base
  def initialize
    api_instance = SibApiV3Sdk::TransactionalEmailsApi.new
  end
end
