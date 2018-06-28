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
      get 'church', to: 'churches#index'
      get 'church/(:church_slug)', to: 'churches#show'
      get 'church/(:church_slug)/guides', to: 'guides#index'
      get 'church/(:church_slug)/guides/(:guide_slug)', to: 'guides#show'
    end
  end
  
  resources :admin, only: [:index] 
  resources :graphics, only: [:index, :create] do
    member do
      get '(:church_slug)', to: 'graphics#church_graphic'
    end
  end
  resources :churches
  resources :guides do
    resources :studies
  end
end
