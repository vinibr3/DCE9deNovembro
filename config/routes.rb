Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  begin
    ActiveAdmin.routes(self)
  rescue Exception => e
    puts "ActiveAdmin: #{e.class}: #{e}"
  end

 
  get 'pages/home',           to:"pages#index",          as: :home
  get 'pages/meia_entrada',   to:"pages#meia_entrada",   as: :meia_entrada
  get 'pages/noticias',       to:"pages#noticias",       as: :noticias
  get 'pages/consulta',       to:"pages#consulta",       as: :consulta
  get 'pages/contato',        to:"pages#contato",        as: :contato
  get 'pages/login',          to:"pages#login",          as: :login


  resources :estudantes, only: [:show, :update] do 
    resources :carteirinhas, only: [:new, :show, :autenticacao, :create]
  end
  
  post 'estudantes/senha',   to:"estudantes#update_password", as: :alterar_password
  get 'entidades/escolaridades', to:"entidades#escolaridades"
  get 'entidades/cursos', to:"entidades#cursos"

  resources :contatos, only:[:create]

  devise_for :estudantes, path: "auth", controllers: {:omniauth_callbacks=>"estudantes/omniauth_callbacks"},
                          path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', 
                                                                confirmation: 'verification', unlock: 'unblock', 
                                                                registration: 'register', sign_up: 'cmon_let_me_in' }

  # Rotas de Escolaridades/Cursos (usadas para obter lista de cursos)                                                           
  #get 'escolaridade/:escolaridade_id/curso', to:'cursos#show'
  resources :escolaridades, only: [:show] do
    resource :cursos, only: [:show]
  end

  # Rota para obter status_versao_impressas via ajax
  get 'carteirinhas/status', to: "carteirinhas#status_versao_impressas"

  # Rotas de UF/Cidades (usadas para obter lista de cidades)
  resources :estados, only: [:show] do
    resource :cidades, only: [:show]
  end

  # Rotas Pagseguro Payment
  get 'payment/checkout',          to:'checkout#create',        as: :checkout
  get 'payment/confirmacao',      to:'checkout#confirmacao'
  post 'payment/notifications',    to:'notifications#create'
  
  get 'carteirinhas/image', to:'carteirinhas#carteirinha_image'
  post 'carteirinhas/consulta',   to:"carteirinhas#consulta", as: :consulta_carteirinha

  get 'certificados/:chave_acesso', to:"certificados#show"

  resources :eventos, only: [:show]

  # Rotas da API 
  namespace :api, defaults:{format: :json} do
    resources :estudantes, only: [:update], param: :oauth_token do
      resources :carteirinhas, only: [:create, :show]
    end
    get 'carteirinhas',          to: 'carteirinhas#index'
    get 'sessions/new',          to: 'sessions#create'   
    get 'sessions/new/facebook', to: 'sessions#facebook'
    post 'registration',         to: 'registrations#create' 
    resources :noticias, only:[:index]

    # Certificado de atributo
    post 'certificados/create', to:'certificados#create'  # cria certificados
  
    # Controla Attachments
    get 'estudantes/:id/attachments/:name', to: 'attachments#show' 
    put 'estudantes/:id/attachments/update/:name', to: 'attachments#update'
  end

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
end
