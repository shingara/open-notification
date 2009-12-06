require 'mail'
class MailNotification

  include Nanite::Actor

  expose :notif

  def initialize
    super
    require 'config_mail'
  end
  
  def notif(payload)
    mail = Mail.new do
      from FROM_MAIL
      to payload['to']
      subject payload['subject']
      body payload['body']
    end
    mail.deliver!
  rescue
    false
  end
end
