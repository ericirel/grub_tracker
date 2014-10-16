class GrubbersController < ApplicationController
  require 'mandrill'

  def message
    @message = params[:body]
    #send messages!
    Grubber.email_grubbers(message)
    Grubber.text_grubbers(message)
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
