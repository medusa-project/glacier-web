Rails.application.routes.draw do
  scope defaults: {format: :json} do
    resources :roots
  end
end
