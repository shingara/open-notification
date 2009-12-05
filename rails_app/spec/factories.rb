class Randgen

  def self.email(options = {})
    domain = options.fetch(:domain, "#{word(options)}.example.org")
    "#{word(options)}@#{domain}"
  end

end

Factory.define :user do |c|
  c.login { /\w+/.gen }
  c.email { /[:email:]/.gen }
  c.firstname { /\w+/.gen }
  c.lastname { /\w+/.gen }
  c.global_admin false
  c.password 'tintinpouet'
  c.password_confirmation 'tintinpouet'
end

Factory.define :admin, :parent => :user do |u|
  u.global_admin true
end

Factory.define :message do |m|
  m.body { /[:paragraph:]/.gen }
  m.from_id { Factory(:user).id }
  m.message_kinds { [Factory.build(:jabber)] }
end

Factory.define :jabber, :class => :message_kind do |j|
  j.to { /[:email:]/.gen }
  j.channel { 'jabber' }
  j.send_at { Time.now }
end
