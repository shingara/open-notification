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
      if payload['content-type'] == 'text/html'
        html_part do
          content_type 'text/html; charset=UTF-8'
          body payload['body']
        end
      else
        body payload['body']
      end
    end
    mail.deliver!
  rescue
    false
  end
end
