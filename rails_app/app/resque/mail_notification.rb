class MailNotification

  @queue = :notification

  def self.perform(ids, options)
    require 'mail'
    message_id, message_kind_id = ids
    Mail.defaults do
       sendmail
    end
    mail = Mail.new do
      from configatron.email.from
      to options['to']
      subject options['subject']
      if options['content-type'] == 'text/html'
        html_part do
          content_type 'text/html; charset=UTF-8'
          body options['body']
        end
      else
        body options['body']
      end
    end
    mail.deliver!

    Message.find(message_id).message_kinds.detect{|message_kind| message_kind.id.to_s == message_kind_id }.update_send_at
  end
end

