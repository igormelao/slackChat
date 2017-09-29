Rails.application.routes.draw do
  get 'team_users/create'

  get 'team_users/destroy'

  root to: 'teams#index'
  get '/:slug', to: 'teams#show'
  resources :teams  , only: [:create, :destroy]
  devise_for :users, :controllers => { registrations: 'registrations' }
end
