class Grubber < ActiveRecord::Base
  require 'mandrill'
  scope :subscribed, ->{ where(subscribed: true) }
  scope :emailable, ->{ where(email_ok: true, subscribed: true) }
  scope :textable, ->{ subscribed.where(text_ok: true) }
  scope :find_grubber, ->(params_key) { where('email = ? or mobile = ?', "#{params_key}", "#{params_key}") }
  validates :password, presence: true
  validates :email, uniqueness: true
  validates :mobile, uniqueness: true
  validates :email, presence: {
        message: "Must provide email or mobile number.",
        unless: Proc.new {|grubber| grubber.mobile.present?} }

  validates :mobile, presence: {
        message: "Must provide email or mobile number.",
        unless: Proc.new {|grubber| grubber.email.present?} }
  before_create :configure_new_grubber
  before_validation :normalize_mobile

  def either_email_or_mobile_present
    if email.present?
  end

  def noramailze_mobile
    self.mobile = GlobalPhone.normalize(self.mobile)
  end

  def configure_new_grubber
      self.subscribed = true
    if self.mobile.present?
       self.text_ok = true
    end
    if self.email.present?
       self.email_ok = true
    end
  end


  # def send_email(message_body)
  #   m = Mandrill::API.new
  #   recipient = [email]
  #   message = {
  #     :subject=> "Grub alert!",
  #     :from_name=> "Grub Tracker",
  #     :text=> message_body,
  #     :to=> recipient,
  #     :html=>"<html><h1><strong>#{message_body}</strong>, Grub Tracker</h1></html>",
  #     :from_email=>"tehsheepy@gmail.com"
  #     }
  #     sending = m.messages.send message
  #     puts sending
  #   end

  # end

  def send_text(message_body)
    # TWILIO_ACCOUNT = ENV['GRUBBER_TWILIO_ACCOUNT']
    # TWILIO_TOKEN = ENV['GRUBBER_TWILIO_SECRET']
    # TWILIO_NUMBER = ENV['GRUBBER_SYSTEM_NUMBER']
    mobile = self.mobile
    @client = Twilio::REST::Client.new TWILIO_ACCOUNT, TWILIO_TOKEN

    message = @client.account.messages.create(
    :body => message_body,
    :to => mobile,
    :from => grubber_system_number)
    puts message.to
  end

  def self.text_grubbers(message_body)
    Grubber.textable.each do |grubber|
      grubber.send_text(message_body)
    end
  end

  def send_email(message_body)
      m = Mandrill::API.new
      recipient = [{email: self.email}]
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

    def self.email_grubbers(message_body)
      Grubber.emailable.each do |grubber|
        grubber.send_email(message_body)
      end
    end
  end
end
