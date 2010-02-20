class MessageKind
  include MongoMapper::EmbeddedDocument

  CHANNEL = ['jabber', 'mail']

  key :to, String, :required => true
  key :channel, String, :required => true
  key :status, String
  key :send_at, Time

  def send_notification
    if channel == "jabber"
      notification(JabberNotification, _root_document.subject, _root_document.body)
    elsif channel == 'mail'
      notification(MailNotification, _root_document.subject, _root_document.body)
    else
      raise "We can't know this type. Need a nanite agent"
    end
  end

  def notification(klass, subject, text)
    Resque.enqueue(klass, [_root_document.id.to_s, self.id.to_s], {'to' => self.to,
                   'subject' => subject,
                   'content-type' => _root_document.content_type,
                   'body' => text})
  end

  def update_send_at
    self.send_at = Time.now
    save
  end

end
