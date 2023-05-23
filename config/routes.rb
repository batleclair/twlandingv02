Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords" }

  devise_scope :user do
    get 'users/info', to: "users/registrations#info"
    get 'users', to: "users/registrations#new"
    get 'users/passwords/choose', to: "users/passwords#choose", as: :choose_password
  end

  # static pages
  root to: "pages#home"
  get "associations", to: "pages#nonprofits", as: :nonprofits
  get "talents", to: "pages#candidates", as: :talents
  get "entreprises", to: "pages#companies", as: :companies
  get "about", to: "pages#about"
  get "terms", to: "pages#terms"
  get "legal", to: "pages#legal"
  get "privacy-policy", to: "pages#privacy"
  get '/companies', to: redirect('/entreprises')
  get '/nonprofits', to: redirect('/associations')
  get '/candidates', to: redirect('/talents')

  # profile routes
  post "candidates/synch", to: "candidates#synch_create", as: :candidates_synch_create
  patch "candidates/:id/synch", to: "candidates#synch_update", as: :candidates_synch_update
  # patch "candidates/:id/synch_min", to: "candidates#synch_update_min"
  get "users/situation", to: "candidates#edit"
  get "users/skills", to: "candidates#skillset"
  get "users/wishes", to: "candidates#wishes"
  get "users/completed", to: "candidates#completed"
  resources :candidates, only: %i[show new create update] do
    resources :experiences, only: %i[create]
  end
  resources :experiences, only: %i[update destroy]
  get "experiences/:id/select", to: "experiences#select", as: :experience_select


  # offer and candidacy routes
  get "missions/mission_indisponible", to: "offers#dead", as: :dead_offer
  get "offers/:slug/select", to: "offers#select", as: :offer_select
  get "offers/:id/preview", to: "offers#preview", as: :offer_preview
  resources :missions, controller: 'offers', as: :offers, param: :slug, only: %i[index show] do
    resources :candidacies, only: :create
  end
  resources :candidacies, only: :show
  post "offers/:id/check", to: "candidacies#check", as: :candidacy_check
  get '/offers', to: redirect('/missions')
  get '/offers/:slug', to: redirect('/missions/%{slug}')

  # beneficiaries routes
  get "associations/asso_indisponible", to: "beneficiaries#unpublished", as: :unpublished_beneficiary
  get "associations/:slug", to: "beneficiaries#show", as: :beneficiary
  post "/associations", to: "beneficiaries#create", as: :beneficiaries
  patch "/associations/:slug", to: "beneficiaries#update"
  delete "/associations/:slug", to: "beneficiaries#destroy"
  patch "beneficiaries/:slug/destroy_img", to: "beneficiaries#destroy_img", as: :destroy_img

  # blog post routes
  resources :blog, controller: 'posts', as: :posts, param: :slug, only: %i[index show]
  resources :blog, controller: 'posts', as: :posts, only: %i[create update destroy]
  get '/posts', to: redirect('/blog')
  get '/posts/*other', to: redirect('/blog')

  # list routes
  # resources :offer_lists, param: :slug, only: %i[show]
  get "/selection/:slug", to: "offer_lists#show", as: :offer_selection
  resources :offer_lists, only: %i[create update destroy] do
    resources :offer_bookmarks, only: %i[create]
  end
  resources :offer_bookmarks, only: %i[destroy]

  # admin routes
  get "/admin", to: "admin#dashboard"
  resources :contacts, only: %i[create update destroy]
  resources :candidacies, only: %i[destroy]
  resources :candidates, only: %i[destroy]
  namespace :admin do
    resources :beneficiaries, param: :slug, only: %i[index new edit]
    resources :offers, param: :slug, only: %i[index new edit create update destroy]
    resources :contacts, only: %i[index]
    resources :candidacies, only: %i[index show]
    resources :posts, only: %i[index new edit]
    resources :candidates, only: %i[index show]
    resources :offer_lists, only: %i[index new edit]
    resources :users, only: %i[new create index destroy]
    resources :companies
  end

  # error routes
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"

  # sitemap
  get 'sitemap', to: 'pages#sitemap', defaults: { format: 'xml' }
end
