class Brevo::Mail
  attr_accessor :template_id, :to, :name, :params

  def initialize(options={})
    self.name = options[:name]
    self.template_id = options[:template_id]
    self.to = options[:to]
    self.params = options[:params]
  end

  def to_email
    smtp_email = SibApiV3Sdk::SendSmtpEmail.new
    smtp_email = {
      'to': [{
        'email': @to,
        'name': @name
      }],
      'templateId': @template_id,
      'params': @params,
      'headers': {
        'X-Mailin-custom'=>'custom_header_1:custom_value_1|custom_header_2:custom_value_2'
      }
    };
    return smtp_email
  end

  def deliver
    EmailDeliveryJob.perform_later(self.to_email)
  end
end
