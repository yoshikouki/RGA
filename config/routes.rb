Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  get 'battles/battle'
  get 'battles', to: 'battles#index'
  get 'pages/home'
  root to: 'pages#home'
end
