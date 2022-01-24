Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root 'static_pages#home'
  get 'home', to: 'static_pages#home', as: 'home'
  get 'help', to: 'static_pages#help', as: 'help'
  get 'about', to: 'static_pages#about', as: 'about'
  devise_for :users, path: 'users', module: 'users'
  devise_scope :user do
    get 'users/home', to: 'users/users#home', as: 'user_home'
    get 'users/cancel', to: 'users/registrations#cancel'
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  resources :users, only: [:show], module: 'users'
  resources :users, module: 'users' do
    member { get 'following' }
  end
  resources :roasters do
    collection { get 'cancel' }
    member { get 'followers' }
  end
  resources :beans
  resources :offers
  resources :roaster_relationships, only: %i[create destroy]
end
