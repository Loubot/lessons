Rails.application.routes.draw do
  devise_for  :teachers, :controllers => { :registrations => "registrations",
                                         omniauth_callbacks: "omniauth_callbacks"}
  resources   :teachers, only: [:update, :edit, :destroy] do
  	member do 
  		get     '/teachers-area'		      =>  'teachers#teachers_area'
      get     '/edit-appointments'      =>  'teachers#edit_appointments'
      get     '/qualification-form'     =>  'teachers#qualification_form'
      get     '/your-location'          =>  'teachers#your_location'      
      post    '/change-profile-pic'     =>  'teachers#change_profile_pic'        
  	end
  	resources :photos, only: [:create, :destroy]
    resources :qualifications, only: [:create, :destroy, :edit]
    resources :openings, only: [:create, :update]
    resources :events

  end
  resources :experiences,   only: [:create, :update, :destroy]
  resources :categories,    only: [:update, :create, :destroy]
  resources :subjects,      only: [:update, :create, :destroy] do
    member do      
      post    '/add-teacher'          =>  'subjects#add_subject_to_teacher'
      delete  '/remove-from-teacher'  =>  'subjects#remove_subject_from_teacher'
    end
  end

  get         '/learn'                  =>  'static#learn'
  get         '/teach'                  =>  'static#teach'
  get         '/welcome'                =>  'static#welcome'
  get         '/subject-search'         =>  'static#subject_search'
  get         '/display-subjects'       =>  'static#display_subjects'
  get         '/how-it-works'           =>  'static#how_it_works'
  get         '/mailing-list'           =>  'static#mailing_list'
  get         '/browse-categories'      =>  'static#browse_categories'
  get         '/refresh-welcome'        =>  'static#refresh_welcome'
  post        '/add-to-list'            =>  'static#add_to_list'

  get         'paypal-create'           =>  'payments#paypal_create'
  get         'paypal-return'           =>  'payments#paypal_return' 
  get         'stripe-auth-user'        =>  'payments#stripe_auth_user' 
  post        'store-paypal'            =>  'payments#store_paypal'
  post        'stripe-create'           =>  'payments#stripe_create'
  post        '/store-stripe'           =>  'payments#store_stripe'

  post        'events/create-event-and-book' => 'events#create_event_and_book'


  get         '/show-teacher'           =>  'teachers#show_teacher'  
  get         '/teacher-subject-search' =>  'teachers#teacher_subject_search'


  get         'admin-panel'             =>  'admins#admin_panel'
  put         'make_admin'              =>  'admins#make_admin'

  root to: 'static#welcome'
end
