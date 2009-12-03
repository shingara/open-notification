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

Factory.define :jabber do |j|
  j.to { /[:email:]/.gen }
  j.text { /[:paragraph:]/.gen }
  j.from_id { Factory(:user).id }
  j.send_at { Time.now }
end
