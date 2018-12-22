Rails.application.routes.draw do

  get 'rfid/board'
  get 'rfid/index'

  devise_for :users
  root 'children#main'
  
  get 'nokogiri/region'
  get 'nokogiri/frequent'
  get 'nokogiri/school' # school zone data db 넣기
  get 'nokogiri/initialize_x_y'
  get 'nokogiri/position'
  post 'nokogiri/save_position'
  get 'nokogiri/get_position'
  get 'nokogiri/distance'
  get 'nokogiri/danger2' # Danger db 추가 넣기
  get 'roo/danger'

  get 'crawling/crawling_view'
 
  # intro
  get '/children/intro'
  get '/children/main'
  
  # Kakao ChatBot
  get  '/keyboard' => "kakaos#keyboard"
  post '/message' => "kakaos#message"

  
  # Kindergarden Controller - start
  get 'kindergardens/search'
  get 'kindergardens/search_result'
  get 'kindergardens/show/:id' => 'kindergardens#show'
  get 'kindergardens/inEdit/:id' => 'kindergardens#inEdit'
  post 'kindergardens/inUpdate' => 'kindergardens#inUpdate'
  get 'kindergardens/ajaxCall'
  get 'kindergardens/getSigun'
  get 'kindergardens/getAccident/:id' => "kindergardens#getAccident"
  get 'kindergardens/getPub/:id' => "kindergardens#getPub"
  get 'kindergardens/getSmoke'
  get 'kindergardens/getSchool/:id' => "kindergardens#getSchool"
  get 'kindergardens/infiscroll'
  get 'kindergardens/gotoposi/:id' => 'kindergardens#gotoposi'
  post 'kindergardens/getKinder'
  get 'kindergardens/gotoform/:id' =>'kindergardens#gotoform'
  # Kindergarden Controller - end
  
  # Child CRUD - start
  get 'children/new'
  post 'children/create'

  get 'children/index'
  get 'children/show/:id' => 'children#show'
  get 'children/myChildren/:id' => 'children#myChildren'
  get 'children/search'
  get 'children/search_result'
  get 'children/explaination'
  
  get 'children/edit/:id' => 'children#edit'
  post 'children/update/:id' => 'children#update'

  get 'children/destroy/:id' => 'children#destroy'

  get 'children/:id/ajax_show' => 'children#ajax_show'
  get 'children/getInfo/:id' => 'children#getInfo'
  # Child CRUD - end
  
  # Receipt CRUD -start
  get 'receipts/new/:id' => 'receipts#new'
  post 'receipts/create'

  get 'receipts/index'
  
  get 'receipts/accept/:id' => 'receipts#accept'
  get 'receipts/deny/:id' => 'receipts#deny'
  # Receipt CRUD - end
  
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
