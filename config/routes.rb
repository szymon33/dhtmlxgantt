Rails.application.routes.draw do
  resources :gantts, only: [:index] do
    collection do
      get  :data, as: 'data'
      post :db_action, :as => "db_action"
    end
  end

  root to: 'gantts#index'
end
