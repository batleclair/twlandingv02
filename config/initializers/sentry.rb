Sentry.init do |config|
  config.dsn = 'https://a80c07df481cf5d0cdfb82086e86356a@o4506819331489792.ingest.sentry.io/4506819334373376'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.enabled_environments = %w[production]
  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end
