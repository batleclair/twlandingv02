Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }

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
  get "offers/mission_indisponible", to: "offers#dead", as: :dead_offer
  get "offers/:slug/select", to: "offers#select", as: :offer_select
  resources :offers, param: :slug, only: %i[index show] do
    resources :candidacies, only: :create
  end
  post "offers/:id/check", to: "candidacies#check", as: :candidacy_check

  # beneficiaries routes
  get "associations/asso_indisponible", to: "beneficiaries#unpublished", as: :unpublished_beneficiary
  get "associations/:slug", to: "beneficiaries#show", as: :beneficiary
  post "/associations", to: "beneficiaries#create", as: :beneficiaries
  patch "/associations/:slug", to: "beneficiaries#update"
  delete "/associations/:slug", to: "beneficiaries#destroy"
  patch "beneficiaries/:slug/destroy_img", to: "beneficiaries#destroy_img", as: :destroy_img

  # blog post routes
  get "/blog", to: "posts#index"
  get "/blog/:slug", to: "posts#show", as: :article
  resources :posts, only: %i[create update destroy]

  # list routes
  resources :offer_lists, param: :slug, only: %i[show]
  resources :offer_lists, only: %i[create update destroy] do
    resources :offer_bookmarks, only: %i[create]
  end
  resources :offer_bookmarks, only: %i[destroy]

  # admin routes
  get "/admin", to: "admin#dashboard"
  resources :contacts, only: %i[create update destroy]
  resources :offers, param: :slug, only: %i[create update destroy]
  resources :candidacies, only: %i[destroy]
  resources :candidates, only: %i[destroy]
  namespace :admin do
    resources :beneficiaries, param: :slug, only: %i[index new edit]
    resources :offers, param: :slug, only: %i[index new edit]
    resources :contacts, only: %i[index]
    resources :candidacies, only: %i[index show]
    resources :posts, only: %i[index new edit]
    resources :candidates, only: %i[index]
    resources :offer_lists, only: %i[index new edit]
  end

  # error routes
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"

  # sitemap
  get 'sitemap', to: 'pages#sitemap', defaults: { format: 'xml' }
end
