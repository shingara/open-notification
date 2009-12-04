class MessageKind
  include MongoMapper::EmbeddedDocument

  CHANNEL = ['jabber']

  key :to, String, :required => true
  key :channel, String, :required => true
  key :status, String
  key :send_at, Time

  def send_notification
    if channel == "jabber"
      notification('/jabber_notification/notif', _root_document.body)
    else
      raise "We can't know this type. Need a nanite agent"
    end
  end

  def notification(url, text)
    Nanite.request(url, {'to' => self.to, 'body' => text}) { |response| update_send_at }
  end

  def update_send_at
    self.send_at = Time.now
    save
  end

end
