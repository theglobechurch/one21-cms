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
  
  resources :admin, only: [:index] 
  resources :churches
end
