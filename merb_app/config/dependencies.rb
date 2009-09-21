# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.
merb_gems_version = "1.0.11"

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
dependency "merb-core", merb_gems_version 
dependency "merb-action-args", merb_gems_version
dependency "merb-assets", merb_gems_version  
dependency("merb-cache", merb_gems_version) do
  Merb::Cache.setup do
    register(Merb::Cache::FileStore) unless Merb.cache
  end
end
dependency "merb-helpers", merb_gems_version 
dependency "merb-slices", merb_gems_version  
dependency "merb-auth-core", merb_gems_version
dependency "merb-auth-more", merb_gems_version
dependency "merb-auth-slice-password", merb_gems_version
dependency "merb-param-protection", merb_gems_version
dependency "merb-exceptions", merb_gems_version
dependency "merb-haml", merb_gems_version

dependency "ezmobius-nanite", "0.4.1.1", :require_as => 'nanite' 
dependency "mongomapper", :require_as => 'mongomapper'
dependency "shingara-merb_mongomapper", "0.1.5",:require_as => 'merb_mongomapper'
dependency "yeastymobs-machinist_mongomapper", :source => 'http://gems.github.com', :require_as => 'machinist/mongomapper'
dependency "thin"
dependency "randexp"
dependency "will_paginate_couchrest", "3.0.1", :require_as => "will_paginate"
