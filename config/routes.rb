Rails.application.routes.draw do
  devise_for :teachers, :controllers => { :registrations => 'registrations' }
  resources :teachers, only: [:update, :edit, :destroy] do
  	member do 
  		get '/teachers-area'		  => 'teachers#teachers_area'
      get '/edit-appointments'  => 'teachers#edit_appointments'
      get '/qualification-form' => 'teachers#qualification_form'
  	end
  	resources :photos
    resources :qualifications, only: [:create, :destroy, :edit]
    resources :events
  end
  
  resources :categories, only: [:update, :create, :destroy]
  resources :subjects, only: [:update, :create, :destroy]

  get '/how-it-works'     => 'static#how_it_works'
  get '/mailing-list'     => 'static#mailing_list'
  post '/add-to-list'     => 'static#add_to_list'
  get 'admin-panel'       => 'admins#admin_panel'
  put 'make_admin'        => 'admins#make_admin'
  root to: 'static#how_it_works'
end
