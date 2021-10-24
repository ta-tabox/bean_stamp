Rails.application.routes.draw do
  root 'static_pages#home'
  get 'home', to: 'static_pages#home', as: 'home'
  get 'help', to: 'static_pages#help', as: 'help'
  get 'about', to: 'static_pages#help', as: 'about'
  devise_for :users, path: 'users', module: 'users'
  resources :users, only: %i[show]
  get 'users/home'
end
