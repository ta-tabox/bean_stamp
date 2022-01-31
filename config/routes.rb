Rails.application.routes.draw do
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
        get 'wants', to: 'users#wants'
      end
      member do
        get 'following', to: 'users#following'
      end
    end
  end
  resources :roasters do
    collection { get 'cancel' }
    member { get 'followers' }
  end
  resources :beans do
    resources :offers, only: [:new]
  end
  resources :offers do
    resources :wants, only: %i[index create]
  end
  resources :roaster_relationships, only: %i[create destroy]
  resources :wants, only: %i[destroy show] do
    member do
      patch 'receipt', to: 'wants#receipt'
    end
  end
end
