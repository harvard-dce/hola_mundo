Rails.application.routes.draw do
  mount DceLti::Engine => "/lti"

  resources :videos, only: [:index, :new, :create, :destroy, :update]

  resource :video, only: [] do
    member do
      get 'my', to: :show
    end
  end

  resource :course, only: [] do
    member do
      get :edit
      patch :update
    end
  end

  root to: 'videos#index'
end
