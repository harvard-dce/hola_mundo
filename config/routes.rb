Rails.application.routes.draw do
  mount DceLti::Engine => "/lti"

  resources :videos, only: [:index, :new, :create]

  root to: 'videos#index'
end
