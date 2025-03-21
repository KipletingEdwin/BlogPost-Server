Rails.application.routes.draw do
  post '/signup', to: 'users#signup'
  post '/login', to: 'users#login'

  resources :posts do
    resources :comments, only: [:create, :update, :destroy]
  end
end
