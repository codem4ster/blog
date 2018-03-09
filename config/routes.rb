Rails.application.routes.draw do
  localized do
    root to: 'site#home'

    resources :users
    namespace 'users' do
      get 'entrance'
      post 'login'
      get 'registration'
      post 'register'
    end
  end
  get 'captcha', to: 'application#captcha'
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
