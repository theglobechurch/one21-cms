Rails.application.routes.draw do
  root to: "landing#index"

  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'signin',
               sign_out: 'signout'
             },
             controllers: {
               registrations: 'registrations'
             }

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

  resources :graphics, only: %i[index create] do
    member do
      get '(:church_slug)', to: 'graphics#church_graphic'
    end
  end

  resources :churches

  get '/guides', to: redirect('/admin', status: 302)
  get '/guides/(:guide)/studies', to: redirect('/guides/%{guide}', status: 302)
  resources :guides, except: [:index] do
    resources :studies, except: [:index]
    member do
      post '/reorder', to: 'guides#reorder'
    end
  end

end
