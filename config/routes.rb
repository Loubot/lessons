Rails.application.routes.draw do
  devise_for  :teachers, :controllers => { :registrations => 'registrations' }
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

  get         '/subject-search'         =>  'static#subject_search'
  get         '/show-teacher'           =>  'teachers#show_teacher'  
  get         '/display-subjects'       =>  'static#display_subjects'
  get         '/teacher-subject-search' =>  'teachers#teacher_subject_search'
  get         '/how-it-works'           =>  'static#how_it_works'
  get         '/mailing-list'           =>  'static#mailing_list'
  post        '/add-to-list'            =>  'static#add_to_list'
  get         'admin-panel'             =>  'admins#admin_panel'
  put         'make_admin'              =>  'admins#make_admin'
  root to: 'static#how_it_works'
end
