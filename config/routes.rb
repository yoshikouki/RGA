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

  get '/job_change', to: 'players#jobs.html.haml', as: 'jobs_index'
  post 'players/job_change', to: 'players#job_change', as: 'job_change'
  get 'battles/battle'
  get 'battles', to: 'battles#index'
  get '/introduction', to: 'pages#introduction'
  get 'pages/home'
  root to: 'pages#home'
end
