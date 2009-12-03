ActionController::Routing::Routes.draw do |map|
  map.devise_for :users
  map.resources :users
  map.resources :jabbers, :only => [:create, :new, :index]
  map.root :controller => 'jabbers', :action => 'index'
end
