require 'rubygems'
require 'sinatra'
require 'nanite'
require 'haml'
require 'yaml'

require 'couchrest'


SERVER = CouchRest.new
SERVER.default_database = 'jabber-notification'

class User < CouchRest::ExtendedDocument
  use_database SERVER.default_database

  property :email
  property :hashed_password
  property :salt

  view_by :email

  attr_accessor :password, :password_confirmation

  timestamps!

  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) if !self.salt
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  private

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

end

configure do
  #Starting mapper to nanite agent
  Thread.new do
    until EM.reactor_running?
      sleep 1
    end
    conf = YAML::load_file('config.yml')
    Nanite.start_mapper(:host => conf[:host], :user => conf[:user], :pass => conf[:pass], :vhost => conf[:vhost], :log_level => conf[:log_level])
  end

end

get '/' do
  haml :index
end

post '/jabber' do
  Nanite.request('/jabber_notification/notif', 'to' => params[:to], 'text' => params[:text])
  redirect '/'
end

get '/signup' do
  haml :signup
end

post '/signup' do
  @user = User.new(params[:user])
  if @user.save
    session[:user] = @user.id
    redirect '/'
  else
    session[:flash] = "failure!"
    redirect '/'
  end
end

get '/users' do
  @users = User.all
  haml :users
end

__END__

@@layout
%html
  %body
    = yield

@@users
%h1 Users
%ul
  - @users.each do |user|
    %li= user.email

@@signup
%h1 Signup
%form{:action => "/signup", :method => "post"}
  %input{ :id => "user_email", :name => "user[email]", :size => 30, :type => "text" }
  email
  %br
  %input{ :id => "user_password", :name => "user[password]", :size => 30, :type => "password" }
  password
  %br
  %input{ :id => "user_password_confirmation", :name => "user[password_confirmation]", :size => 30, :type => "password" }
  confirm
  %br
  %input{ :value => "sign up", :type => "submit" }

@@index
%form{:method => 'post', :action => "/jabber"}
  %p
    %label To :
    %input{:type => 'text', :name => 'to'}
  %p
    %label Message
    %textarea{:name => 'text'}
  %p
    %input{:type => 'submit'}
