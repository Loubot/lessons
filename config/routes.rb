Rails.application.routes.draw do
  devise_for :teachers
  resources :teachers

  get '/how-it-works'     => 'static#how_it_works'
  get '/mailing-list'     => 'static#mailing_list'
  post '/add-to-list'      => 'static#add_to_list'
  root to: 'static#how_it_works'
end
