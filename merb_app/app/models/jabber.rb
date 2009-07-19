class Jabber < CouchRest::ExtendedDocument

  include CouchRest::Validation
  
  property :to
  property :text
  property :from
  property :send_at

  timestamps!

  validates_present :to
  validates_present :text
  validates_present :from

  view_by :from , :map => "function(doc) {
      if ((doc['couchrest-type'] == 'Jabber') && doc['from']) {
        emit([doc['from'], doc['created_at']], null);
      }
  }"
  view_by :to


  def send_notification
    if valid?
      Nanite.request('/jabber_notification/notif', 'to' => to, 'text' => text) do |response|
        self.send_at = Time.now
        self.save
      end
    end
  end
end
