Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  # static pages
  root to: "pages#home"
  get "nonprofits", to: "pages#nonprofits"
  get "candidates", to: "pages#candidates"
  get "companies", to: "pages#companies"
  get "about", to: "pages#about"
  get "terms", to: "pages#terms"
  get "legal", to: "pages#legal"

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
  get "offers/:slug/select", to: "offers#select", as: :offer_select
  resources :offers, param: :slug, only: %i[index show] do
    resources :candidacies, only: :create
  end
  post "offers/:id/check", to: "candidacies#check", as: :candidacy_check

  # blog post routes
  get "/blog", to: "posts#index"
  get "/blog/:slug", to: "posts#show", as: :article
  resources :posts, only: %i[create update destroy]

  # admin routes
  get "/admin", to: "admin#dashboard"
  resources :contacts, only: %i[create update destroy]
  resources :beneficiaries, only: %i[create update destroy]
  patch "beneficiaries/:id/destroy_logo", to: "beneficiaries#destroy_logo", as: :destroy_logo
  resources :offers, param: :slug, only: %i[create update destroy]
  resources :candidacies, only: %i[destroy]
  resources :candidates, only: %i[destroy]
  namespace :admin do
    resources :beneficiaries, only: %i[index new edit]
    resources :offers, param: :slug, only: %i[index new edit]
    resources :contacts, only: %i[index]
    resources :candidacies, only: %i[index show]
    resources :posts, only: %i[index new edit]
    resources :candidates, only: %i[index]
  end

  # sitemap
  get 'sitemap', to: 'pages#sitemap', defaults: { format: 'xml' }
end
