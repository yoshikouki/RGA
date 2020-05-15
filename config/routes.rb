Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               confirmations:      'users/confirmations',
               passwords:          'users/passwords',
               registrations:      'users/registrations',
               sessions:           'users/sessions',
               unlocks:            'users/unlocks',
               omniauth_callbacks: 'users/omniauth_callbacks'
             }

  get 'battles/battle'
  get 'battles', to: 'battles#index'
  get 'pages/home'
  root to: 'pages#home'
end
