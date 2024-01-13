Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'users/info', to: "users/registrations#info"
    get 'users', to: "users/registrations#new"
    get 'users/passwords/choose', to: "users/passwords#choose", as: :choose_password
  end

  # tenant routes
  constraints(Subdomain.new("tenant")) do

    get '/validation', to: "pages#unconfirmed", as: :unconfirmed_user

    scope module: "company_admin" do
      scope path: "/admin" do
        get "/", to: "pages#dashboard", as: :company_admin
        get "/info", to: "pages#info", as: :company_admin_info
        resources :users, except: %i[show], as: :company_admin_users
        patch "/users", to: "users#destroy_multiple", as: :destroy_company_admin_users
        resources :whitelists, only: %i[index new create edit update destroy], as: :company_admin_whitelists
        patch "/whitelists", to: "whitelists#destroy_multiple", as: :destroy_company_admin_whitelists
        post "/whitelists/upload", to: "whitelists#upload", as: :upload_company_admin_whitelists
        post "/whitelists/save_batch", to: "whitelists#save_batch", as: :save_company_admin_whitelists
        resources :recherche, controller: 'offers', as: :company_admin_offers, param: :slug, only: %i[index]
        resources :recherche, controller: 'offers', as: :company_admin_offers, param: :slug, only: %i[show] do
          resources :candidacies, only: %i[create]
        end
        resources :eligibilities, controller: 'employee_applications', as: :company_admin_employee_applications, only: %i[index show update]
        resources :candidatures, controller: 'candidacies', as: :company_admin_candidacies, only: %i[index update]
        resources :missions, as: :company_admin_missions, only: %i[show index update] do
          resources :contracts, only: %i[new create]
        end
        resources :activated_missions, as: :company_admin_activated_missions, only: %i[show index]
        resources :candidatures, controller: 'candidacies', as: :company_admin_candidacies, only: %i[show] do
          resources :missions, only: %i[new create]
        end
        resources :contracts, as: :company_admin_contracts, only: %i[destroy]
        resources :candidates, as: :company_admin_candidates, only: %i[update]
      end
    end

    scope module: "company_user" do
      get "/", to: "pages#dashboard"
      get "/info", to: "pages#info", as: :user_info
      get "/on-boarding", to: "pages#on_boarding", as: :user_onboarding
      get "/mission", to: "pages#no_mission", as: :user_no_mission
      patch "/book-call", as: :user_booked_call, to: "pages#book_call", defaults: { format: :json }
      resources :candidates, as: :user_candidates, only: :update
      resources :experiences, as: :user_experiences
      patch "/mon_profil/user", to: "candidates#set_user", as: :set_user_profile
      get "/mon_profil", to: "candidates#profile", as: :user_profile
      resources :ma_demande, controller: 'employee_applications', as: :user_employee_applications, only: %i[new create show]
      get "/ma_demande", to: redirect("/")
      # get "/ma_demande", to: "employee_applications#renew", as: :renew_user_employee_application
      resources :recherche, controller: 'offers', as: :user_offers, param: :slug, only: %i[index show] do
        resources :candidacies, only: %i[new create update]
        # resources :selections, only: %i[create]
        resources :favoris, as: :bookmarks, controller: 'bookmarks', only: %i[create]
      end
        get "recherche/:slug/candidacies", to: redirect("recherche/%{slug}")
        get "recherche/:slug/candidacies/:id", to: redirect("recherche/%{slug}")
      resources :candidacies, as: :user_candidacies, only: %i[index show update]
      resources :selections, as: :user_selections, only: %i[index show edit update]
      resources :favoris, controller: 'bookmarks', as: :user_bookmarks, only: %i[index show update destroy]
      resources :missions, as: :user_missions, only: %i[index edit update]
      get "/historique/candidatures", to: "candidacies#historicals", as: :user_past_candidacies
      get "/historique/missions", to: "missions#historicals", as: :user_past_missions
      resources :missions, as: :user_missions, only: %i[show] do
        get "confirmation", to: "missions#confirm"
        get "terminated", to: "missions#terminated"
        resources :timesheets
        resources :feedbacks, only: %i[new edit create update]
      end
    end

  end

  # API
  constraints subdomain: /.*/ do
    namespace :api, defaults: { format: :json } do
      namespace :v1 do
        get ":aircandidate_id/:airoffer_id", to: "candidacies#show"
        post ":aircandidate_id/:airoffer_id", to: "candidacies#create"
        patch ":aircandidate_id/:airoffer_id", to: "candidacies#update"
      end
    end
  end

  # static pages available to all
  root to: "pages#home"
  get "about", to: "pages#about"
  get "terms", to: "pages#terms"
  get "legal", to: "pages#legal"
  get "privacy-policy", to: "pages#privacy"

  constraints(Subdomain.new("generic")) do
  # static pages
    get "associations", to: "pages#nonprofits", as: :nonprofits
    get "talents", to: "pages#candidates", as: :talents
    get "entreprises", to: "pages#companies", as: :companies
    get '/companies', to: redirect('/entreprises')
    get '/nonprofits', to: redirect('/associations')
    get '/candidates', to: redirect('/talents')

    # profile routes
    post "candidates/synch", to: "candidates#synch_create", as: :candidates_synch_create
    patch "candidates/:id/synch", to: "candidates#synch_update", as: :candidates_synch_update
    # patch "candidates/:id/synch_min", to: "candidates#synch_update_min"
    # post "offers/:slug/candidates", to: "candidates#apply", as: :candidate_apply
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
    # post "offers/:id/check", to: "candidacies#check", as: :candidacy_check
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
      resources :candidacies
      resources :posts, only: %i[index new edit]
      resources :candidates, only: %i[index show destroy]
      resources :offer_lists, only: %i[index new edit]
      resources :users, only: %i[new edit create update index destroy]
      resources :companies do
        resources :questions
        resources :whitelists
        resources :eligibility_periods
      end
      patch '/companies/:id/reset_demo', to: "companies#reset_demo", as: :reset_company_demo
      resources :offer_rules, only: %i[edit update]
      resources :employee_applications, only: %i[edit update index destroy]
      resources :missions, only: %i[edit index update destroy]
    end

    # sitemap
    get 'sitemap', to: 'pages#sitemap', defaults: { format: 'xml' }
  end

  # error routes
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"

end
