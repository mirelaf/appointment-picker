Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "locations#index"

  resources :locations do
    resources :appointments
  end

  get "locations/:id/find_slots" => "locations#find_slots", as: "location_find_slots"
end
