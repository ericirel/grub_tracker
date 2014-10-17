module ApplicationHelper

  def current_grubber
    session[:grubber_id] ? Grubber.find(session[:grubber_id]) : nil
  end
end
