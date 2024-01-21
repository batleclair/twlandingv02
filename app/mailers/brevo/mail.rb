class Brevo::Mail
  attr_accessor :template_id, :to, :name, :params

  def initialize(options={})
    # self.name = options[:name]
    @to = options[:to]
    @template_id = options[:template_id]
    @params = options[:params]
  end

  def to_email
    smtp_email = SibApiV3Sdk::SendSmtpEmail.new
    smtp_email = {
      # 'to': [{
      #   'email': @to,
      #   'name': @name
      # }],
      'to': @to,
      'templateId': @template_id,
      'params': @params,
      'headers': {
        'X-Mailin-custom'=>'custom_header_1:custom_value_1|custom_header_2:custom_value_2'
      }
    };
    return smtp_email
  end

  # def add(recipient)
  #   self.to << recipient.to_h
  # end

  def deliver
    EmailDeliveryJob.perform_now(self.to_email)
  end
end
