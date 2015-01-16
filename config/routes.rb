Rails.application.routes.draw do
  get 'admin/index'
  get 'admin/data', as: 'data'
  post "admin/db_action", :as => "db_action"

  root :to => 'admin#index'
end
