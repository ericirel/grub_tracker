class TwilioController < ApplicationController

  skip_before_action :verify_authenticity_token

  def sms
    @message = params[:Body]
    Grubber.email_grubbers(message)
    Grubber.text_grubbers(message)
    render status: :ok
  end

end
