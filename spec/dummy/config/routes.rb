Rails.application.routes.draw do
  mount ObjectView::Engine => "/object_view"
  resource :people
end
