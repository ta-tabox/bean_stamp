Rails.application.routes.draw do
  get 'likes/index'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root 'static_pages#home'
  get 'home', to: 'static_pages#home', as: 'home'
  get 'help', to: 'static_pages#help', as: 'help'
  get 'about', to: 'static_pages#about', as: 'about'
  devise_for :users, path: 'users', module: 'users'
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  scope module: 'users' do
    resources :users, only: [:show] do
      collection do
        get 'home', to: 'users#home'
      end
      member do
        get 'following', to: 'users#following'
      end
    end
  end
  resources :roasters do
    collection do
      get 'home'
      get 'cancel'
    end
    member { get 'followers' }
  end
  resources :beans do
    resources :offers, only: [:new]
  end
  resources :offers do
    collection { get 'search' }
    member do
      get 'wanted_users'
      get 'liked_users'
    end
    resources :wants, only: %i[create]
    resources :likes, only: %i[create]
  end
  resources :roaster_relationships, only: %i[create destroy]
  resources :wants, only: %i[index show destroy] do
    collection { get 'search' }
    member do
      patch 'receipt', to: 'wants#receipt'
      patch 'rate', to: 'wants#rate'
    end
  end
  resources :likes, only: %i[index destroy]
end
