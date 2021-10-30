Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root 'static_pages#home'
  get 'home', to: 'static_pages#home', as: 'home'
  get 'help', to: 'static_pages#help', as: 'help'
  get 'about', to: 'static_pages#about', as: 'about'
  devise_for :users, path: 'users', module: 'users'
  devise_scope :user do
    get 'users/home', to: 'users/users#home'
  end
  resources :users, only: [:show], module: 'users'
end
