Rails.application.routes.draw do

  root 'public/welcome#index'

  get 'terms/',   to: 'public/terms#index'
  get 'about/',   to: 'public/terms#about_page'
  get 'faq/'  ,   to: 'public/common_questions#index'
  get 'sign-up',  to: 'public/registrations#new'
  post 'sign-up', to: 'public/registrations#create'
  get 'sign-out', to: 'public/authentication#destroy'
  get 'sign-in',  to: 'public/authentication#new'
  post'sign-in',  to: 'public/authentication#create'


  resources :tasks, module: :private do
    resources :comments, only:[:create]
  end

  resources :users, module: :private
  resources :projects, module: :private do
    resources :tasks
    resources :memberships, except:[:show, :edit]
  end

  resources :tracker_projects, only:[:show], module: :private

end
