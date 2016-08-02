Rails.application.routes.draw do
  scope defaults: {format: :json} do
    resources :roots do
      get :archives, on: :collection
    end
    resources :archives
  end
end
