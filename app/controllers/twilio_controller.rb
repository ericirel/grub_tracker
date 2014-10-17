class TwilioController < ApplicationController

  skip_before_action :verify_authenticity_token

  def sms
    message = params[:Body]
    grubber = Grubber.find_by_mobile(params[:From])
    if grubber
      Grubber.email_grubbers(message)
      Grubber.text_grubbers(message)
    end
    render status: :ok
  end

end
