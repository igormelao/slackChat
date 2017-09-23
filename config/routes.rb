Rails.application.routes.draw do
  root to: 'teams#index'
  get '/:slug', to: 'teams#show'
  resources :teams  , only: [:create, :destroy]
  devise_for :users, :controllers => { registrations: 'registrations' }
end
