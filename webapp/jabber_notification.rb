require 'sinatra'
require 'nanite'
require 'haml'
require 'yaml'

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

__END__

@@ layout
%html
  %body
    = yield

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
