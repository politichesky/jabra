Ssr::Application.routes.draw do
  
  resources :users
  resources :tasks
  resources :projects
  resources :sessions, :only => [:new, :create, :destroy]
  resources :comments, :only => [:create, :destroy]
  
  match 'task/:id/confirm' => 'statuses#confirm'
  match 'task/:id/done' => 'statuses#done'
  match 'task/:id/abort' => 'statuses#abort'
  
  match 'tasks/sort_by_status/:status_id' => 'tasks#sort_by_status'
  match 'tasks/sort_by_user/:user_id' => 'tasks#sort_by_user'
  match 'tasks/sort_by_author/:author_id' => 'tasks#sort_by_author'

  match '/signup', :to => 'users#new'
  match '/login', :to => 'sessions#new'
  match '/logout', :to => 'sessions#destroy'
  
  match '/about', :to => "pages#about"

  match '/inbox/:user_id' => 'tasks#sort_by_user'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "pages#home"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
