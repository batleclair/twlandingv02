Rails.application.routes.draw do
  devise_for :users

  # static pages
  root to: "pages#home"
  get "nonprofits", to: "pages#nonprofits"
  get "candidates", to: "pages#candidates"
  get "companies", to: "pages#companies"
  get "about", to: "pages#about"

  # profile routes
  post "candidates/synch", to: "candidates#synch_create"
  patch "candidates/:id/synch", to: "candidates#synch_update"
  patch "candidates/:id/synch_min", to: "candidates#synch_update_min"
  resources :candidates, only: %i[show new edit create update] do
    resources :experiences, only: %i[create]
  end
  resources :experiences, only: %i[update destroy]
  get "experiences/:id/select", to: "experiences#select", as: :experience_select

  # offer and candidacy routes
  get "offers/:id/select", to: "offers#select", as: :offer_select
  resources :offers, only: %i[index show edit update destroy] do
    resources :candidacies, only: %i[new create]
    post "check", to: "candidacies#check", as: :candidacy_check
  end

  # blog post routes
  get "/blog", to: "posts#index"
  get "/blog/:title", to: "posts#show", as: :article
  resources :posts, only: %i[create update destroy]
  # namespace :blog do
  #   resources :posts, only: %i[show]
  # end

  # admin routes
  get "/admin", to: "admin#dashboard"
  resources :contacts, only: %i[create update destroy]
  resources :beneficiaries, only: %i[create update destroy]
  resources :offers, only: %i[create update destroy]
  resources :candidacies, only: %i[destroy]
  namespace :admin do
    resources :beneficiaries, only: %i[index new edit]
    resources :offers, only: %i[index new edit]
    resources :contacts, only: %i[index]
    resources :candidacies, only: %i[index show]
    resources :posts, only: %i[index new edit]
  end

end
