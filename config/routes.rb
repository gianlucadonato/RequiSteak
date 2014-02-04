Requisteak::Application.routes.draw do
  resources :integration_tests

  resources :units

  resources :components

  resources :validation_tests

  resources :system_tests

  resources :use_cases

  resources :requirements

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  get '/downloads'                => 'download#index'
  get '/downloads/use_cases'      => 'download#export_use_cases', as: 'downloads_use_cases'
  get '/downloads/requirements'   => 'download#export_requirements', as: 'downloads_requirements'
  get '/downloads/back-end'       => 'download#export_backend', as: 'downloads_backend'
  get '/downloads/front-end'      => 'download#export_frontend', as: 'downloads_frontend'

  get '/downloads/system_test_requirements'          => 'download#export_ts_req', as: 'downloads_ts_req'
  get '/downloads/validation_test_requirements'      => 'download#export_tv_req', as: 'downloads_tv_req'

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
