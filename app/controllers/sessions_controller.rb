class SessionsController < ApplicationController

  def new

  end

  def create
    login = params[:email] unless login
    @grubber = Grubber.find_grubber(login).first
    if @grubber and @grubber.password == params[:password]
      session[:grubber_id] = @grubber.id
      flash[:notice] = "You logged in Grubber!"
      redirect_to message_path
    else
      flash[:alert] = "Something went wrong. Try again!"
      redirect_to root_path
    end
  end

  def destroy
    session[:grubber_id] = nil
    flash[:notice] = "You logged out."
    redirect_to root_path
  end

end
