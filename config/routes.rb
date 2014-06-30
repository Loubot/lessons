Rails.application.routes.draw do
  devise_for :teachers
  resources :teachers, only: [:update, :edit, :destroy] do
  	member do 
  		get '/teachers-area'		=> 'teachers#teachers_area'
  	end
  	resources :photos
    resources :qualifications, only: [:create, :destroy, :edit]
  end
  resources :events
  resources :categories, only: [:update, :create, :destroy]
  resources :subjects, only: [:update, :create, :destroy]

  get '/how-it-works'     => 'static#how_it_works'
  get '/mailing-list'     => 'static#mailing_list'
  post '/add-to-list'     => 'static#add_to_list'
  get 'admin-panel'       => 'admins#admin_panel'
  root to: 'static#how_it_works'
end
