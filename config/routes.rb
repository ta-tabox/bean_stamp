Rails.application.routes.draw do
  get 'users/home'
  get 'users/show'
  devise_for :users, path: 'users', module: 'users'

  # devise_scope :user do
  #   get 'users/home', to: 'users/users#home'
  #   get 'users/show', to: 'users/users#show'
  # end

  root 'static_pages#home'
  get 'home', to: 'static_pages#home', as: 'home'
  get 'help', to: 'static_pages#help', as: 'help'
  get 'about', to: 'static_pages#help', as: 'about'
end
