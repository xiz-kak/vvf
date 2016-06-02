Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  scope '(:locale)', locale: /en|vi|ja/ do
    root 'discover#top'
    resources :users  do
      member do
        get :activate
      end
    end
    resources :languages
    resources :categories
    resources :nations
    resources :divisions
    resources :payment_vendors
    resources :app_settings, :except => [:new, :create, :destroy]
    resources :faqs
    resources :projects do
      member do
        get 'preview' => 'projects#preview'
        get 'edit_rewards' => 'projects#edit_rewards'
        get 'discard' => 'projects#discard'
        get 'apply' => 'projects#apply'
        get 'remand' => 'projects#remand'
        get 'approve' => 'projects#approve'
        get 'resume' => 'projects#resume'
        get 'suspend' => 'projects#suspend'
        get 'drop' => 'projects#drop'
        get 'pay'
        get 'pay_back'
      end
      collection do
        get 'pledge_list'
        get 'start' => 'projects#start'
        get 'complete'
        get 'cancel'
      end
    end
    get 'project/:project_code' => 'projects#show_by_code', as: :project_by_code
    get 'rewards/:reward_code/new_pledge' => 'pledges#new', as: :new_pledge
    post 'shipping_rate' => 'pledges#shipping_rate'
    resources :pledges, :except => :new do
      member do
        get 'pay'
        get 'pay_back'
        get 'complete'
        get 'cancel'
      end
    end

    get 'login' => 'user_sessions#new', :as => :login
    post 'logout' => 'user_sessions#destroy', :as => :logout
    post 'user_sessions' => 'user_sessions#create', :as => :user_sessions

    post 'oauth/callback' => 'oauths#callback'
    get 'oauth/callback' => 'oauths#callback' # for use with Github, Facebook
    get 'oauth/:provider' => 'oauths#oauth', :as => :auth_at_provider

    get 'discover/top'
    get 'discover/search'
    get 'discover/category/:id' => 'discover#category', as: :discover_category

    get 'pages/faq'

    resources :password_resets
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
