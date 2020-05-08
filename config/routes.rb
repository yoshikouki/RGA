Rails.application.routes.draw do
  get 'battles/battle'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  get 'pages/home'
  root to: 'pages#home'
end
