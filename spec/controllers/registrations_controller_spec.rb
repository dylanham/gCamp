require 'rails_helper'

describe RegistrationsController do
  describe 'GET #new' do
    it 'should render a new view' do
      get :new

      expect(response).to render_template(:new)
    end

    it 'should have a new user object' do
      get :new

      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create'do
    describe "on success" do
      it "creates a new User when valid parameters are passed" do
        expect {
          post :create, user: { first_name: 'Billy', last_name: 'Bob', email: 'billybob@example.com', password: 'password' }
        }.to change { User.all.count }.by(1)

        user = User.last
        expect(session[:user_id]).to eq(user.id
        )
        expect(user.first_name).to eq "Billy"
        expect(user.last_name).to eq "Bob"
        expect(flash[:notice]).to eq "You have successfully signed up"
        expect(response).to redirect_to root_path
      end
    end

    describe "on failure" do
      it "does not create a user if it is invalid" do
        expect {
          post :create, user: { first_name: nil, last_name: nil, email: nil, password: nil }
        }.to_not change { User.all.count }

        expect(response).to render_template(:new)
        expect(assigns(:user)).to be_a(User)
      end
    end
  end
end
