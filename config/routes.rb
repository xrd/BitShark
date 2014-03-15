Plbh::Application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/signout', to: 'sessions#destroy'
  get '/facebook/friends', to: "facebook#friends"
  post '/facebook/invite', to: "facebook#invite"
  get '/payment/sponsor/:code', to: "payment#sponsor_received"
  get '/payment/loan/:code', to: "payment#loan_received"
  get '/payment/button/:code', to: "payment#button"
  
  get '/invite', to: 'welcome#index'
  get '/loans', to: 'welcome#index'
  get '/home', to: 'welcome#index'
  get '/donate', to: 'welcome#index'
  get '/help', to: 'welcome#index'
  get '/sponsor', to: 'welcome#index'
  
  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :loans do
    collection do
      get :all
    end
  end

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
