Rails.application.routes.draw do
  scope defaults: {format: :json} do
    resources :roots do
      get :archives, on: :collection
      get :archives_for_file, on: :collection
    end
    resources :archives
    namespace :job do
      resources :root_backups, only: :create
    end
  end
end
