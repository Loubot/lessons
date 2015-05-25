Rails.application.routes.draw do
  devise_for  :teachers, :controllers => {  omniauth_callbacks: "authentications",
                                            :registrations => "registrations", 
                                            passwords: 'passwords'
                                          }
  resources   :teachers, only: [:update, :edit, :destroy] do
    
  	member do 
  		get     '/teachers-area'		      =>  'teachers#teachers_area'
      get     '/edit-appointments'      =>  'teachers#edit_appointments'
      get     '/qualification-form'     =>  'teachers#qualification_form'
      get     '/your-business'          =>  'teachers#your_business'
      get     'previous-lessons'        =>  'teachers#previous_lessons'
      get     'modal'                   =>  'teachers#modals'      
      post    '/change-profile-pic'     =>  'teachers#change_profile_pic'       
  	end
  	resources :photos, only: [:create, :destroy]
    resources :qualifications, only: [:create, :destroy, :edit]
    resources :openings, only: [:create, :update]
    resources :events
    resources :identities, only: [:destroy]

    resources :grinds, only: [:create, :destroy]
    
    resources :packages, only: [:create, :destroy]


  end
  get         '/show-teacher'           =>  'teachers#show_teacher'  
  get         '/teacher-subject-search' =>  'teachers#teacher_subject_search'
  get         '/add-map'                =>  'teachers#add_map'
  get         'get-locations'           =>  'teachers#get_locations'
  get         'get-subjects'            =>  'teachers#get_subjects'
  get         'get-locations-price'     =>  'teachers#get_locations_price'

  resources :locations, only: [:create, :update, :destroy]

  resources :prices, only: [:create, :update, :destroy]
  
  resources :experiences,   only: [:create, :update, :destroy]
  resources :categories,    only: [:update, :create, :destroy]
  resources :subjects,      only: [:update, :create, :destroy] do
    member do      
      post    '/add-teacher'          =>  'subjects#add_subject_to_teacher'
      delete  '/remove-from-teacher'  =>  'subjects#remove_subject_from_teacher'
    end
  end
  resources :reviews, only: [:create, :destroy]
  get         '/learn'                  =>  'static#learn'
  get         '/teach'                  =>  'static#teach'
  get         '/welcome'                =>  'static#welcome'
  get         '/subject-search'         =>  'static#subject_search'
  get         '/display-subjects'       =>  'static#display_subjects'
  get         '/how-it-works'           =>  'static#how_it_works'
  get         '/mailing-list'           =>  'static#mailing_list'
  get         '/browse-categories'      =>  'static#browse_categories'
  get         '/refresh-welcome'        =>  'static#refresh_welcome'
  get         '/new-registration'       =>  'static#new_registration'
  get         '/register-with-us'       =>  'static#landing_page'
  post        '/add-to-list'            =>  'static#add_to_list'
  post        '/confirm-registration'   =>  'static#confirm_registration'

  post        '/share-linkedin'         =>  'application#share_linkedin'
  

  #Paypal
  get         'paypal-create'           =>  'paypal#paypal_create'
  get         'paypal-return'           =>  'paypal#paypal_return' 
  post        'home-booking-paypal'     =>  'paypal#home_booking_paypal'
  post        'store-paypal'            =>  'paypal#store_paypal'
  post        'package-paypal'          =>  'paypal#create_package_booking_paypal'
  post        'store-package-paypal'    =>  'paypal#store_package_paypal'

  post        'pay-membership-paypal'     =>  'paypal#pay_membership_paypal'
  post        'membership-return-paypal'  =>  'paypal#membership_return_paypal'

  #Stripe
  get         'stripe-auth-user'        =>  'stripe#stripe_auth_user'  
  post        'stripe-create'           =>  'stripe#stripe_create'
  post        'home-booking-stripe'     =>  'stripe#home_booking_stripe'
  post        'store-stripe'            =>  'stripe#store_stripe'
  post        'package-stripe'          =>  'stripe#create_package_booking_stripe'
  post        'pay-membership-stripe'   =>  'stripe#pay_membership_stripe'
  post        'pay-membership-return-stripe'  =>  'stripe#membership_return_stripe'

  post        'events/create-event-and-book' => 'events#create_event_and_book'
  post        'events/check-home-event'      => 'events#check_home_event'


  get         'admin-panel'             =>  'admins#admin_panel'
  put         'make_admin'              =>  'admins#make_admin'
  
  root to: 'static#welcome'
end
