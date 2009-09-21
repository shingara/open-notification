class Jabber < CouchRest::ExtendedDocument

  include CouchRest::Validation
  
  key :to, String, :required => true
  key :text, String, :required => true
  key :from_id, String, :required => true
  key :send_at, Time

  timestamps!

  validates_present :to
  validates_present :text
  validates_present :from

  view_by :from , :map => "function(doc) {
      if ((doc['couchrest-type'] == 'Jabber') && doc['from']) {
        emit([doc['from'], doc['created_at']], null);
      }
  }"

  view_by :count_from , :map => "function(doc) {
      if ((doc['couchrest-type'] == 'Jabber') && doc['from']) {
        emit(doc['from'], 1);
      }
  }",
  :reduce => "function(key,values) {
    return sum(values);
  }"
  view_by :to


  after_create :send_notification

  def send_notification
    if valid?
      Nanite.request('/jabber_notification/notif', 
                     'to' => to, 
                     'text' => text) do |response|
        self.send_at = Time.now
        save
      end
    end
  end

end
