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
match 'editions', to: 'pages#editions', via: [:get], as: :editions
match 'intro_praxis', to: 'pages#intro_praxis', via: [:get], as: :intro_praxis
match 'b_praxis', to: 'pages#b_praxis', via: [:get], as: :b_praxis
match 't_praxis', to: 'pages#t_praxis', via: [:get], as: :t_praxis
match 'p_praxis', to: 'pages#p_praxis', via: [:get], as: :p_praxis
match 'br_praxis', to: 'pages#br_praxis', via: [:get], as: :br_praxis
match 'encod_praxis', to: 'pages#encod_praxis', via: [:get], as: :encod_praxis
match 'b_manuscript', to: 'pages#b_manuscript', via: [:get], as: :b_manuscript
match 't_manuscript', to: 'pages#t_manuscript', via: [:get], as: :t_manuscript
match 'p_manuscript', to: 'pages#p_manuscript', via: [:get], as: :p_manuscript
match 'br_manuscript', to: 'pages#br_manuscript', via: [:get], as: :br_manuscript
match 'b_translation', to: 'pages#b_translation', via: [:get], as: :b_translation
match 'hell_scene', to: 'pages#hell_scene', via: [:get], as: :hell_scene
match 'versioning', to: 'pages#versioning', via: [:get], as: :versioning
match 'cite', to: 'pages#cite', via: [:get], as: :cite
# match 'bibliography', to: 'pages#bibliography', via: [:get], as: :bibliography
match 'biblio_temp', to: 'pages#biblio_temp', via: [:get], as: :biblio_temp

end
