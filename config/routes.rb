Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  get 'pages/home'
  root to: "pages#home"
end
