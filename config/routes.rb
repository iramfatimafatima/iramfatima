Rails.application.routes.draw do
  devise_for :users

  resources :teams do
    member do
      post 'add_member'
      delete 'remove_member/:member_id', to: 'teams#remove_member', as: 'remove_member'
      get 'search_members'
    end
    resources :members, only: [:index, :create, :destroy]
  end
 


  root 'teams#index'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
