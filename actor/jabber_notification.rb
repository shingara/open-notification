require 'xmpp4r'
require 'yaml'
class JabberNotification

  include Nanite::Actor
  include Jabber

  expose :notif

  def initialize
    conf = YAML::load_file('config_jabber.yml')
    jid = JID::new(conf[:jid])
    @cl = Client::new(jid)
    @cl.connect
    @cl.auth(conf[:password])
    super
  end
  
  def notif(payload)
    m = Message::new(payload['to'], payload['text'])
    @cl.send m
  end
end
