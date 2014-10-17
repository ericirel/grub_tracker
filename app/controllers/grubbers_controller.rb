class GrubbersController < ApplicationController
  require 'mandrill'
  before_action :set_grubber, only: [:edit, :update]

  def message
    @message = params[:body]
    #send messages!
    Grubber.email_grubbers(message)
    Grubber.text_grubbers(message)
  end

  def sent
  end

  def show
  end

  def new
    @grubber = Grubber.new
  end

  def create
    @grubber = Grubber.new(grubber_params)
    #configure_new grubber sets additional attributes
    if @grubber.save
      flash[:notice] = "Let's get to grubbing"
      redirect_to message_path
    else
      flash[:alert] = "Something went wrong"
      render :new
    end
  end

  def edit

  end

  def update
    if @grubber.update(grubber_params)
      flash[:notice] = "Grubber successfully updated!"
      redirect_to root_path
    else
      flash[:alert] = "Something went wrong"
      render :edit
    end
  end

  private

  def grubber_params
    params.require(:grubber).permit(:email, :mobile, :password, :email_ok, :text_ok, :subscribed)
  end

  def set_grubber
    @grubber = Grubber.find(params[:id])
  end
end
