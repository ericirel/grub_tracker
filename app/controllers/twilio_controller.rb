class TwilioController < ApplicationController


  def sms
    @message = params[:Body]
    Grubber.email_grubbers(message)
    Grubber.text_grubbers(message)
    render status :ok
  end

end
