require 'xmpp4r'
require 'yaml'

class JabberNotification
  @queue = :notification

  def self.perform(ids, options)
    message_id, message_kind_id = ids
    conf = YAML::load_file(Rails.root.to_s + '/config/resque/config_jabber.yml')
    jid = Jabber::JID::new(conf[:jid])
    cl = Jabber::Client::new(jid)
    cl.connect
    cl.auth(conf[:password])
    cl.send Jabber::Message::new(options['to'], options['body'])
    Message.find(message_id).message_kinds.detect{|message_kind| message_kind.id.to_s == message_kind_id }.update_send_at
  end

end
