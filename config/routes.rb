Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#index'

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

  # Configures store endpoint in your app
# mount AnnotatorStore::Engine, at: '/annotator_store'

get "/pages/:page" => "pages#show"
# get "/pages/:page", to: "pages#show", as: ':page'

# match 'index', to: 'pages#index', via: [:get], as: :root
match 'bibliography', to: 'pages#bibliography', via: [:get], as: :bibliography
match 'editions', to: 'pages#editions', via: [:get], as: :editions

match 'b_manuscript', to: 'pages#b_manuscript', via: [:get], as: :b_manuscript
match 't_manuscript', to: 'pages#t_manuscript', via: [:get], as: :t_manuscript
match 'p_manuscript', to: 'pages#p_manuscript', via: [:get], as: :p_manuscript
match 'br_manuscript', to: 'pages#br_manuscript', via: [:get], as: :br_manuscript
match 'hell_scene', to: 'pages#hell_scene', via: [:get], as: :hell_scene

end
