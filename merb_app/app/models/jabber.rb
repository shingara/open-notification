class Jabber < CouchRest::ExtendedDocument

  include CouchRest::Validation
  
  property :to
  property :text


  def send_notification
    Nanite.request('/jabber_notification/notif', 'to' => to, 'text' => text)
  end
end
