# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
use_test :rspec
use_template_engine :haml
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '6f29bcb20c69d0d74c786a6bab7caabd7f41f4d0'  # required for cookie session store
  c[:session_id_key] = '_merb_app_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
  Thread.new do
    until EM.reactor_running?
      sleep 1
    end
    Nanite.start_mapper(:host => 'localhost', :user => 'nanite', :pass => 'testing', :vhost => '/nanite', :log_level => 'info')
  end
end
