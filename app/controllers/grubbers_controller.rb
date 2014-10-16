class GrubbersController < ApplicationController

  def message
    @message = params[:body]
    #send messages!
    puts "****** Sending Messages ******"
    require 'mandrill'
    m = Mandrill::API.new
    message = {
      :subject=> "Grub alert!",
      :from_name=> "Grub Tracker",
      :text=> @message,
      :to=>[
      {
      :email=> "tehsheepy@gmail.com",
      :name=> "Eric Herskovic"
    }
  ],
    :html=>"<html><h1>Hi <strong>#{@message}</strong>, Grub Tracker</h1></html>",
    :from_email=>"sender@yourdomain.com"
    }
    sending = m.messages.send message
    puts sending
  end

  def index
  end

  def show
  end

  def new
    @grubber = Grubber.new
  end

  def create
    @grubber = Grubber.new(params.require(:grubber).permit(:email, :mobile, :password))

    #configure_new grubber sets additional attributes
    if @grubber.save
      flash[:notice] = "Let's get to grubbing"
      redirect_to root_path
    else
      flash[:alert] = "Something went wrong"
      render :new
    end
  end

  def edit
  end
end
