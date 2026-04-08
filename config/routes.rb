Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  devise_for :users
  root to: "pages#home"

  # about
  get "quem-somos", to: "pages#about", as: :about

  # contact
  get "contato", to: "pages#contact", as: :contact

  # budget
  get "orcamento", to: "pages#budget", as: :budget

  # policies
  get "politicas-de-privacidade", to: "pages#privacy_policies", as: :privacy_policies
  get "politicas-de-cookies", to: "pages#cookies_policies", as: :cookies_policies
  get "termos-de-uso", to: "pages#terms_of_use", as: :terms_of_use

  resources :contact_messages, only: [ :create ]
  resources :budget_requests, only: [ :create ]

  # services and products
  resources :services, only: [ :index, :show ], path: "servicos"
  get "produtos/serras-circulares", to: "products#circular_saw", as: :circular_saw_products
  get "produtos/laminas-de-serra-fita", to: "products#band_saw", as: :band_saw_products
  get "serras-circulares", to: "products#circular_saw"
  get "laminas-de-serra-fita", to: "products#band_saw"
  resources :products, only: [ :show ], path: "produtos"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Allow direct access to products by slug at root level (primary route)
  get ":slug", to: "products#show", as: :product_root

  scope "painel-servicos-hiperion", as: :secret do
    resources :services, except: [ :index, :show ], path: "servicos"
    resources :products, except: [ :index, :show ], path: "produtos" do
      post :reorder, on: :collection
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
