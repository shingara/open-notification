class Jabber

  include MongoMapper::Document

  key :to, String, :required => true
  key :text, String, :required => true
  key :from_id, ObjectId, :required => true
  key :send_at, Time


  timestamps!

  belongs_to :from, :class_name => User

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
