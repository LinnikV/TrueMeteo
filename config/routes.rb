Rails.application.routes.draw do
  resources :news, only: %i[index show]
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  #scope module: 'admin' do
  #  resources :news
  #end

  root 'home_page#index'
  #root 'home#home_page'

  namespace :admin do
    resources :news
    get 'update_news_list', action: :update_news_list, controller: 'news'
  end

  
  get 'index', action: :index, controller: 'home_page'
  post 'search', action: :search, controller: 'home_page'
  
  get 'weather', action: :weather, controller: 'home_page'
  get 'air_quality', action: :air_quality, controller: 'home_page'

end
