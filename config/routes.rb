Rails.application.routes.draw do
  mount DceLti::Engine => "/lti"

  resources :videos, only: [:index, :new, :create]
  resources :courses, only: [] do
    collection do
      post :review_toggle
    end
  end

  root to: 'videos#index'
end
