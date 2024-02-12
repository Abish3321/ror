Rails.application.routes.draw do
  namespace :admin do
    get 'login', to: 'admin#login'
    post 'authenticate', to: 'admin#authenticate'
    get 'dashboard', to: 'admin#dashboard'
    get 'logout', to: 'admin#logout'
    resources :questions
    resources :feedback
  end

  root 'home#index'
  post '/enroll', to: 'home#enroll_user'

  resources :tests, only: [:new, :create, :show] do
    member do
      post 'submit'
      get 'results'
    end
  end
end
