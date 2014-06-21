Rails.application.routes.draw do
  devise_for :teachers
  resources :teachers

  get '/how-it-works' => 'teachers#how_it_works'
  root to: 'teachers#how_it_works'
end
