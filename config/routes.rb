Rails.application.routes.draw do
  resources :appointments, only: [:index, :new, :create, :show]

  get "up" => "rails/health#show", as: :rails_health_check
end
