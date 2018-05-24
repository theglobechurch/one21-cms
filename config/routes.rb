Rails.application.routes.draw do

  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'signin',
      sign_out: 'signout'
    },
    controllers: {
      registrations: 'registrations'
    }
  
  
  root to: "landing#index"

  namespace :api do
    scope module: :v2, constraints: ApiVersion.new('v2') do
      resources :churches, only: [:index]
    end
    scope module: :v1, constraints: ApiVersion.new('v1', true) do
      resources :churches, only: [:index]
    end
  end
  
  resources :admin, only: [:index] 
  resources :churches
end
