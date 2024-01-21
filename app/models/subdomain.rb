class Subdomain

  def initialize(status)
    @status = status
  end

  def matches?(request)
    if @status == "generic"
      request.subdomain == 'www' || request.subdomain.blank?
    elsif @status == "tenant"
      request.subdomain != 'www' && request.subdomain.present?
    else
      super
    end
  end

  def self.generic
    ENV["REDISCLOUD_URL"] ? "www" : ""
    # if Rails.env.production?
    #   "www"
    # else
    #   ""
    # end
  end
end
