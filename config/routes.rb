Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'welcome/index'
 
  root 'welcome#index'

  get 'about' => 'welcome#about'
  get 'contact' => 'welcome#contact'

  # devise_scope :user do
  #   match '/sign-in' => "devise/sessions#new", :as => :login
  # end

  # devise_for :users, :controllers => { :invitations => 'users/invitations', :passwords => "passwords", :sessions => "sessions" }

  # resources :users do
  # end
  # resources :users, :only => [:show]
  resources :users, only: [:index, :disable, :renable] do
    member do
      post :disable
      post :renable
    end
  end
end
