InvisibleCaptcha.setup do |config|
  # config.honeypots           << ['more', 'fake', 'attribute', 'names']
  config.visual_honeypots    = false
  config.timestamp_threshold = 4
  # config.timestamp_enabled   = true
  # config.injectable_styles   = false
  # config.spinner_enabled     = true

  # Leave these unset if you want to use I18n (see below)
  config.sentence_for_humans     = 'Vous cherchez quoi ?'
  config.timestamp_error_message = '👮 Un problème est survenu'
end
