Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get "nonprofits", to: "pages#nonprofits"
  get "candidates", to: "pages#candidates"
  get "companies", to: "pages#companies"
  get "about", to: "pages#about"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :contacts, only: %i[create update destroy]
  resources :beneficiaries, only: %i[create update destroy]
  resources :offers, only: %i[create update destroy]
  resources :candidacies, only: %i[destroy]
  get "offers/:id/select", to: "offers#select", as: :offer_select

  resources :offers, only: %i[index show edit update destroy] do
    resources :candidacies, only: %i[new create]
    post "check", to: "candidacies#check", as: :candidacy_check
  end

  resources :candidates, only: %i[create update]

  get "/admin", to: "admin#dashboard"
  namespace :admin do
    resources :beneficiaries, only: %i[index new edit]
    resources :offers, only: %i[index new edit]
    resources :contacts, only: %i[index]
    resources :candidacies, only: %i[index show]
  end
end
