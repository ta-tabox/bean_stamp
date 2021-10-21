Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               passwords: 'users/passwords',
               registrations: 'users/registrations',
             }
  root 'static_pages#home'
  get 'home', to: 'static_pages#home', as: 'home'
  get 'help', to: 'static_pages#help', as: 'help'
  get 'about', to: 'static_pages#help', as: 'about'
end
