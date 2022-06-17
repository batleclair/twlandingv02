Rails.application.routes.draw do
  root to: "pages#home"
  get "nonprofits", to: "pages#nonprofits"
  get "candidates", to: "pages#candidates"
  get "companies", to: "pages#companies"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :contacts, only: %i[create]
end
