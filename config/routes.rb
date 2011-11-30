# FIXME: Correct way for rails engine routes?
Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :pages
  end

  match '/static/*path', :to => 'static_content#show', :via => :get, :as => 'static'

end
