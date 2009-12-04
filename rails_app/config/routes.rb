ActionController::Routing::Routes.draw do |map|
  map.devise_for :users
  map.resources :users
  map.resources :messages, :only => [:create, :new, :index]
  map.root :controller => 'messages', :action => 'index'
end
