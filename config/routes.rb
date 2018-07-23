Rails.application.routes.draw do
  root 'builds#new'
  get 'builds/new'
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources:builds
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
