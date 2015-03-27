require 'rails_helper'

describe Private::UsersController do
  describe 'GET #index' do
    it 'should render a view for an admin of a list of all users' do
      user = create_user(admin: true)
      user2 = create_user
      session[:user_id] = user.id

      get :index

      expect(assigns(:users)).to eq [user, user2]
      expect(response).to render_template :index
    end

    it 'should render a view for any logged in user' do
      user = create_user
      session[:user_id] = user.id

      get :index

      expect(assigns(:users)).to eq [user]
      expect(response).to render_template :index
    end

    describe 'Permisions' do
      it 'should redirect a non logged in user to sign in' do
        get :index

        expect(response).to redirect_to sign_in_path
        expect(flash[:warning]).to eq 'You must sign in'
      end
    end
  end

  describe 'GET #show' do
    it 'should render the template for a user and have a user object' do
      user = create_user
      session[:user_id] = user.id

      get :show, id: user.id

      expect(assigns(:user)).to eq user
      expect(response).to render_template :show
    end
    describe 'Permisions' do
      it 'should redirect a non logged in user to sign in' do
        user = create_user

        get :show, id: user.id

        expect(response).to redirect_to sign_in_path
        expect(flash[:warning]).to eq 'You must sign in'
      end
    end
  end
  describe 'GET #new' do
    it 'should render the new view and have a new user object for a logged in user' do
      user = create_user
      session[:user_id] = user.id

      get :new

      expect(assigns(:user)).to be_a_new(User)
      expect(response).to render_template :new
    end
    describe 'Permissions' do
      it 'should redirect a non logged in user to sign in' do
        get :new

        expect(response).to redirect_to sign_in_path
        expect(flash[:warning]).to eq 'You must sign in'
      end
    end
  end

  describe 'POST #create' do
    describe 'On Success' do
      it 'should create a new user object for a non admin user when valid params are passed' do
        user = create_user
        session[:user_id] = user.id

        expect{
          post :create, user: { first_name: 'John', last_name: 'Smith', email: 'bobdole@example.com', password: 'password'}
        }.to change { User.all.count }.by(1)

        expect(User.all.last.admin).to eq false
        expect(flash[:notice]).to eq 'User was successfully created'
        expect(response).to redirect_to users_path
      end

      it 'should create a new user  for a non admin without admin true even if hacking params' do
        user = create_user
        session[:user_id] = user.id

        expect{
          post :create, user: { first_name: 'John', last_name: 'Smith', email: 'bobdole@example.com', password: 'password', admin: true }
        }.to change { User.all.count }.by(1)

        expect(User.all.last.admin).to eq false
        expect(flash[:notice]).to eq 'User was successfully created'
        expect(response).to redirect_to users_path
      end

      it 'should create a new user with admin as true if valid params are passed and current user is admin' do
        user = create_user(admin: true)
        session[:user_id] = user.id

        expect{
          post :create, user: { first_name: 'Bill', last_name: 'Ted', email: 'bill@ted.com', password: 'password', admin: true }
        }.to change { User.all.count }.by(1)

        expect(User.all.last.admin).to eq true
        expect(flash[:notice]).to eq 'User was successfully created'
        expect(response).to redirect_to users_path
      end
    end

    describe 'On Failure' do
      it 'should not create a new user when invalid params are passed' do
        user = create_user
        session[:user_id] = user.id

        expect{
          post :create, user: { first_name: nil, last_name: nil, email: nil, password: nil }
        }.to_not change { User.all.count }

        expect(assigns(:user)).to be_a_new(User)
        expect(response).to render_template :new
      end
    end

    describe 'Permissions' do
      it 'should redirect a non logged in user to sign in ' do

        post :create, user: { first_name: 'a', last_name: 'b', email: 'c', password: 'd' }

        expect(response).to redirect_to sign_in_path
        expect(flash[:warning]).to eq 'You must sign in'
      end
    end
  end

  describe 'GET #edit' do
    it 'should render a view for a different user for an admin and have user object' do
      user = create_user(admin: true)
      user2 = create_user
      session[:user_id] = user.id

      get :edit, id: user2.id

      expect(assigns(:user)).to eq user2
      expect(response).to render_template :edit
    end

    it 'should render a view if current_user is self' do
      user = create_user
      session[:user_id] = user.id

      get :edit, id: user.id

      expect(assigns(:user)).to eq user
      expect(response).to render_template :edit
    end

    describe 'Permissions' do
      it 'should redirect a non logged in user to sign in' do
        user = create_user

        get :edit, id: user.id

        expect(response).to redirect_to sign_in_path
        expect(flash[:warning]).to eq 'You must sign in'
      end

      it 'should render a 404 for a non admin non self user' do
        user = create_user
        user2 = create_user
        session[:user_id] = user.id

        get :edit, id: user2.id

        expect(response.status).to eq 404
      end
    end
  end

  describe 'PATCH #update' do
    describe 'On success' do
      it 'should update a user for an admin when valid params are passed' do
        user = create_user(admin: true)
        session[:user_id] = user.id
        user2 = create_user(first_name: 'Jim')

        expect{
          patch :update, id: user2.id, user: { first_name: 'John' }
        }.to change { user2.reload.first_name }.from('Jim').to('John')

        expect(flash[:notice]).to eq 'User was successfully updated'
        expect(response).to redirect_to users_path
      end

      it 'current_user should update self if valid params are passed' do
        user = create_user(first_name: 'Dylan')
        session[:user_id] = user.id

        expect{
          patch :update, id: user.id, user: { first_name: 'John' }
        }.to change { user.reload.first_name }.from('Dylan').to('John')

        expect(flash[:notice]).to eq 'User was successfully updated'
        expect(response).to redirect_to users_path
      end
    end

    describe 'On failure' do
      it 'should not update a user for an admin when valid params are not passed' do
        user = create_user(admin: true)
        session[:user_id] = user.id
        user2 = create_user

        expect{
          patch :update, id: user2.id, user: { first_name: nil, last_name: nil, email: nil, password: nil}
        }.to_not change { user2.reload}

        expect(response).to render_template :edit
      end
    end

    describe 'Permissions' do
      it 'should redirect a non logged in user to sign in' do
        user = create_user

        patch :update, id: user.id

        expect(response).to redirect_to sign_in_path
        expect(flash[:warning]).to eq 'You must sign in'
      end

      it 'should render a 404 for a non admin non self user' do
        user = create_user
        user2 = create_user
        session[:user_id] = user.id

        patch :update, id: user2.id

        expect(response.status).to eq 404
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a user and sets all comments user made to nil if current user is admin and redirects to users path' do
      user = create_user(admin: true)
      session[:user_id] = user.id
      user2 = create_user
      comment = create_comment(user_id: user2.id)

      expect{
        delete :destroy, id: user2.id
      }.to change { User.all.count }.by(-1)

      expect(response).to redirect_to users_path
      expect(flash[:notice]).to eq 'User was successfully deleted'
      expect(comment.reload.user_id).to eq nil
    end

    it 'deletes self for current_user and redirects to root path' do
      user = create_user
      session[:user_id] = user.id

      expect{
        delete :destroy, id: user.id
      }.to change { User.all.count }.by(-1)

      expect(flash[:notice]).to eq 'User was successfully deleted'
      expect(response).to redirect_to users_path
    end
  end

  describe 'Permissions' do
    it 'should redirect a non logged in user to sign up' do
      user = create_user

      expect{
        delete :destroy, id: user.id
      }.to_not change { User.all.count }


      expect(response).to redirect_to sign_in_path
      expect(flash[:warning]).to eq 'You must sign in'
    end

    it 'should render a 404 for a non self user' do
      user = create_user
      user2 = create_user
      session[:user_id] = user.id

      expect {
        delete :destroy, id: user2.id
      }.to_not change { User.all.count }

      expect(response.status).to eq 404
    end
  end
end
