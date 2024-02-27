

Rails.application.routes.draw do
  namespace :admin do
    get 'login', to: 'admin#login'
    post 'authenticate', to: 'admin#authenticate'
    get 'dashboard', to: 'admin#dashboard'
    get 'logout', to: 'admin#logout'

    get 'user_rank', to: 'admin#user_rank'

    resources :users, only: [:index, :destroy]
    resources :questions
    resources :feedback
  end

  root 'home#index'
  post '/enroll', to: 'home#enroll', as: 'enroll'
  get '/test/instructions', to: 'home#test_instructions', as: 'test_instructions'
  get '/test', to: 'home#test_index', as: 'test_index'
  get '/cancel_enrollment', to: 'home#cancel_enrollment', as: 'cancel_enrollment'
  get '/logout', to: 'home#destroy', as: 'logout'
  post '/submit_quiz', to: 'home#submit_quiz'
  get '/test_score', to: 'home#test_score'



end
