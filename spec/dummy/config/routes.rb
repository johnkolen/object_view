Rails.application.routes.draw do
  resources :users
  resources :people
  resources :phone_numbers
  mount ObjectView::Engine => "/object_view"
end
