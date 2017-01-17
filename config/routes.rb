Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  get 'sessions/new'

  resources :blogs
  get '/blogs_management', to: "blogs#management"
  post 'blogs/:id/toggle', to: "blogs#toggle_active"
  resources :static_pages, :only => [:index, :edit, :create, :update]
  get 'home', :to => 'static_pages#home'
  get 'home/edit', :to => 'static_pages#edit_home'
  get 'about_us', :to => 'static_pages#about_us'
  get 'about_us/edit', :to => 'static_pages#edit_about_us'
  get 'woofs_for_help', :to => 'static_pages#woofs_for_help'
  get 'woofs_for_help/edit', :to => 'static_pages#edit_woofs_for_help'
  get 'help', :to => 'static_pages#help'
  get 'help/edit', :to => 'static_pages#edit_help'
  get 'contact_us', :to => 'static_pages#contact_us'
  get 'contact_us/edit', :to => 'static_pages#edit_contact_us'
  get 'foster', to: 'static_pages#foster'
  get 'foster/edit', to: 'static_pages#edit_foster'
  get 'event/edit', to: 'static_pages#edit_event'
  get 'special_event/edit', to: 'static_pages#edit_special_event'
  get 'donate', to: 'static_pages#donate'
  get 'donate/edit', to: 'static_pages#edit_donate'
  get 'adopt/edit', to: 'static_pages#edit_adopt'
  get 'edit_sidebar', :to => 'static_pages#edit_sidebar'
  resources :events
  get 'special_events', :to => "events#special_events"
  get 'adopt', :to => "forms#adopt"
  post 'send_adoption', :to => "forms#send_adoption"
  resources :users
  get '/user/:id/user_management', to: 'users#hierarchy'
  post '/user/:id/user_management', to: 'users#set_hierarchy'
  post '/users/set_state', to: 'users#set_state'
  get 'confirm_email', to: 'users#confirm_email'
  resources :comments
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/confirm_email_login', to: 'sessions#confirm_email_login'
  delete '/logout', to: 'sessions#destroy'
  root to: 'static_pages#home'
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
