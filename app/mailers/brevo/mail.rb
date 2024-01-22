class Brevo::Mail
  attr_accessor :template_id, :to, :name, :params

  def initialize(options={})
    @to = options[:to]
    @template_id = options[:template_id]
    @params = options[:params]
  end

  def to_email
    smtp_email = SibApiV3Sdk::SendSmtpEmail.new
    smtp_email = {
      'to': @to,
      'templateId': @template_id,
      'params': @params,
      'headers': {
        'X-Mailin-custom'=>'custom_header_1:custom_value_1|custom_header_2:custom_value_2'
      }
    };
    return smtp_email
  end

  def deliver
    if Rails.env.production?
      EmailDeliveryJob.perform_later(self.to_email)
    else
      EmailDeliveryJob.perform_now(self.to_email)
    end
  end
end
