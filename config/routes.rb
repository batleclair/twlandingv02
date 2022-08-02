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
  resources :contacts, only: %i[create]
  resources :beneficiaries, only: %i[index show create edit update destroy] do
    resources :offers, only: %i[create]
  end
  resources :offers, only: %i[index show edit update destroy] do
    resources :candidacies, only: %i[new create]
    post "check", to: "candidacies#check", as: :candidacy_check
  end
  resources :candidates, only: %i[create update]
end
