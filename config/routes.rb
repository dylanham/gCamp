Rails.application.routes.draw do

  root 'welcome#index'

  get 'terms/',   to: 'terms#index'
  get 'about/',   to: 'terms#about_page'
  get 'faq/'  ,   to: 'common_questions#index'
  get 'sign-up',  to: 'registrations#new'
  post 'sign-up', to: 'registrations#create'
  get 'sign-out', to: 'authentication#destroy'
  get 'sign-in',  to: 'authentication#new'
  post'sign-in',  to: 'authentication#create'


  resources :tasks do
    resources :comments, only:[:create]
  end

  resources :users
  resources :projects do
    resources :tasks
    resources :memberships, except:[:show, :edit]
  end

end
