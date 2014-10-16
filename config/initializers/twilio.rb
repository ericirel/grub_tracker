require 'twilio-ruby'

TWILIO_ACCOUNT = ENV['GRUBBER_TWILIO_ACCOUNT']
TWILIO_TOKEN = ENV['GRUBBER_TWILIO_SECRET']
TWILIO_NUMBER = ENV['GRUBBER_SYSTEM_NUMBER']

Twilio.configure do |config|
  config.account_sid = account_sid
  config.auth_token = auth_token
end
