# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
use_test :rspec
use_template_engine :haml
Merb.orm = :couchrest
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '6f29bcb20c69d0d74c786a6bab7caabd7f41f4d0'  # required for cookie session store
  c[:session_id_key] = '_merb_app_session_id' # cookie session id key, defaults to "_session_id"
  c[:adapter] = 'thin' unless c[:adapter] == 'irb' || c[:adapter] == 'runner'
end
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
  if Merb.environment != 'test'
    Thread.new do
      until EM.reactor_running?
        sleep 1
      end
      conf = YAML::load_file(Merb.root + '/config/nanite_config.yml')
      Nanite.start_mapper(:host => conf[:host], :user => conf[:user], :pass => conf[:pass], :vhost => conf[:vhost], :log_level => conf[:log_level])
    end
  end
end

require 'lib/open_notification/version.rb'
