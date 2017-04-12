Rails.application.routes.draw do
  
  get 'password_resets/new'

  get 'password_resets/edit'

  # static_pages
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  
  # users
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :users
  
  # authentication
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  # user activation
  resources :account_activations, only: [:edit]
  
  # password reset
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
  # account
  get '/accounts', to: 'static_pages#home'
  resources :accounts
  
  # security account activatino
  resources :security_account_activations, only: [:edit]
end