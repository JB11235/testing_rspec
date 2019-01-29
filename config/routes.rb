Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tasks do
    member do
      get :up
      get :down
  	end
  end
  resources :projects
  root to: "projects#index"
end
