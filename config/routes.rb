Rails.application.routes.draw do

  root 'home_page#index'
  #root 'home#home_page'
  get 'index', action: :index, controller: 'home_page'
  post 'search', action: :search, controller: 'home_page'
  
  get 'weather', action: :weather, controller: 'home_page'
  get 'air_quality', action: :air_quality, controller: 'home_page'

end
