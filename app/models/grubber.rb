class Grubber < ActiveRecord::Base
  scope :subscribed, ->{ where(subscribed: true) }
  scope :emailable, -> { where(email_ok: true, subscribed: true) }
  scope :textable, -> { subscribed.where(text_ok: true) }
  validates :password, presence: true
  before_create :configure_new_grubber

  def configure_new_grubber
      self.subscribed = true
    if self.mobile.present?
       self.text_ok = true
    end
    if self.email.present?
       self.email_ok = true
    end


  def send_email(message_body)
    m = Mandrill::API.new
    recipient = [email]
    message = {
      :subject=> "Grub alert!",
      :from_name=> "Grub Tracker",
      :text=> message_body,
      :to=> recipient,
      :html=>"<html><h1><strong>#{message_body}</strong>, Grub Tracker</h1></html>",
      :from_email=>"tehsheepy@gmail.com"
      }
      sending = m.messages.send message
      puts sending
    end

  end

  def self.email_grubbers(message_body)
    grubber_emails = Grubber.emailable.map do |grubber|
      Hash(email: grubber.email)
    end
    emailable_grubbers.each do |email|
      recipient = [email]
      m = Mandrill::API.new
      message = {
        :subject=> "Grub alert!",
        :from_name=> "Grub Tracker",
        :text=> message_body,
        :to=> recipient,
        :html=>"<html><h1><strong>#{message_body}</strong>, Grub Tracker</h1></html>",
        :from_email=>"tehsheepy@gmail.com"
      }
      sending = m.messages.send message
      puts sending
    end
  end
end
