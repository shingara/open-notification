# # config.ru  
require 'rubygems'  
ENV['INLINEDIR'] = 'tmp/inline'

gems_dir = File.join(File.dirname(__FILE__), 'gems')
$BUNDLE = true; Gem.clear_paths; Gem.path.replace([File.expand_path(gems_dir)])
ENV["PATH"] = "#{File.dirname(__FILE__)}:#{gems_dir}/bin:#{ENV["PATH"]}"
if (local_gem = Dir[File.join(gems_dir, "specifications", "thin-*.gemspec")].last)
  version = File.basename(local_gem)[/-([\.\d]+)\.gemspec$/, 1]
end

require 'merb-core'  
   
Merb::Config.setup(:merb_root => File.expand_path(File.dirname(__FILE__)),  
                   :environment => ENV['RACK_ENV'])  
Merb.environment = "production" #Merb::Config[:environment]  
Merb.root = Merb::Config[:merb_root]  
Merb::BootLoader.run  

# comment this out if you are running merb behind a load balancer
# that serves static files
use Merb::Rack::Static, Merb.dir_for(:public)

# this is our main merb application
run Merb::Rack::Application.new
