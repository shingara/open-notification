class Jabber < CouchRest::ExtendedDocument

  include CouchRest::Validation
  
  property :to
  property :text
  property :from

  timestamps!

  validates_present :to
  validates_present :text
  validates_present :from

  view_by :from
  view_by :to


  def send_notification
    if valid?
      Nanite.request('/jabber_notification/notif', 'to' => to, 'text' => text)
    end
  end
end
