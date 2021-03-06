require 'rails_helper'

describe Private::MembershipsController do
  describe 'GET #index' do
    it 'should have a new membership object' do
      user = create_user
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id)

      get :index, project_id: project.id

      expect(assigns(:membership)).to be_a_new(Membership)
    end

    it 'should have a project' do
      user = create_user
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id)

      get :index, project_id: project.id

      expect(assigns(:project)).to be_a(Project)
    end

    describe "permissions" do
      it 'should redirects non logged in users to sign in path' do

        get :index, project_id: create_project.id

        expect(response).to redirect_to sign_in_path
      end

      it 'should redirect non members to projects path' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        membership = create_membership

        get :index, project_id: create_project.id

        expect(response).to redirect_to projects_path
      end

      it 'should renders the template for members owners and admins' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        membership = create_membership(project_id: project.id, user_id: user.id)

        get :index, project_id: project.id

        expect(response).to render_template :index
      end
    end
  end

  describe 'POST #create'do
    describe "on success" do
      it "creates a new membership when valid parameters are passed and current user is Owner" do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        membership1 = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')
        user2 = create_user

        expect {
          post :create, project_id: project.id, membership: { role: 'Member', user_id: user2.id , project_id: project.id }
        }.to change { Membership.all.count }.by(1)

        membership = Membership.last
        expect(membership.role).to eq "Member"
        expect(membership.user_id).to eq user2.id
        expect(membership.project_id).to eq project.id
        expect(flash[:notice]).to eq "#{membership.user.full_name} was successfully added"
        expect(response).to redirect_to project_memberships_path(project)
      end

      it "creates a new membership when valid parameters are passed and current user is admin" do
        user = create_user(admin: true)
        session[:user_id] = user.id
        project = create_project
        user2 = create_user

        expect {
          post :create, project_id: project.id, membership: { role: 'Member', user_id: user2.id , project_id: project.id }
        }.to change { Membership.all.count }.by(1)

        membership = Membership.last
        expect(membership.role).to eq "Member"
        expect(membership.user_id).to eq user2.id
        expect(membership.project_id).to eq project.id
        expect(flash[:notice]).to eq "#{membership.user.full_name} was successfully added"
        expect(response).to redirect_to project_memberships_path(project)
      end
    end

    describe "on Failure" do
      it 'does not create a membership if it is invalid' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        membership1 = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')

        expect {
          post :create, project_id: project.id, membership: { role: nil, user_id: nil, project_id: nil}
        }.to_not change { Membership.all.count }

        expect(assigns(:membership)).to be_a(Membership)
        expect(response).to render_template(:index)
      end
    end

    describe 'permissions' do
      it 'should redirect a nonmember to projects path' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        user2 = create_user
        membership = create_membership(project_id: project.id, user_id: user2.id)

        expect {
          post :create, project_id: project.id, membership: { role: 'Owner', user_id: create_user, project_id: project.id }
        }.to_not change { Membership.all.count }

        expect(flash[:warning]).to eq 'You do not have access to that project'
        expect(response).to redirect_to projects_path
      end

      it 'should redirect a member who is not an owner or admin to projects path' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        membership1 = create_membership(project_id: project.id, user_id: user.id, role: 'Member')
        user2 = create_user

        expect {
          post :create, project_id: project.id, membership: { role: 'Member', user_id: user2.id , project_id: project.id }
        }.to_not change { Membership.all.count }

        expect(flash[:warning]).to eq 'You do not have access'
        expect(response).to redirect_to projects_path
      end

      it 'should redirects non logged in users to sign in path' do
        expect {
          post :create, project_id: create_project.id
        }.to_not change { Membership.all.count }

        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe 'Patch #update' do
    describe 'On Success' do
      it 'should update an existing membership item if current_user is an owner and params are valid' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        user2 = create_user
        membership1 = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')
        membership2 = create_membership(project_id: project.id, user_id: user2.id, role: 'Member')

        expect {
          patch :update, project_id: project.id, id: membership2.id, membership: { role: 'Owner' }
        }.to change { membership2.reload.role }.from("Member").to("Owner")
        expect(flash[:notice]).to eq "#{membership2.user.full_name} was successfully updated"
        expect(response).to redirect_to project_memberships_path(project)
      end

      it 'should update an existing membership object if valid params are passed current_user is an Admin' do
        user = create_user(admin: true)
        session[:user_id] = user.id
        project = create_project
        user2 = create_user
        membership2 = create_membership(project_id: project.id, user_id: user2.id, role: 'Member')

        expect {
          patch :update, project_id: project.id, id: membership2.id, membership: { role: 'Owner' }
        }.to change { membership2.reload.role }.from("Member").to("Owner")

        expect(flash[:notice]).to eq "#{membership2.user.full_name} was successfully updated"
        expect(response).to redirect_to project_memberships_path(project)
      end
    end

    describe 'On Failure' do
      it 'renders a new template' do
        user = create_user(admin: true)
        session[:user_id] = user.id
        project = create_project
        user2 = create_user
        membership = create_membership(project_id: project.id, user_id: user2.id, role: 'Member')

        expect {
          patch :update, project_id: project.id, id: membership.id, membership: { role: nil }
        }.to_not change { membership.reload.role }

        expect(assigns(:membership)).to eq(membership)
        expect(response).to render_template(:index)
      end
    end

    describe 'Permissions' do
      it 'should redirect a nonmember to projects path' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        user2 = create_user
        membership = create_membership(project_id: project.id, user_id: user2.id)

        expect {
          patch :update, project_id: project.id, id: membership.id, membership: { role: 'Owner' }
        }.to_not change { membership.reload.role }

        expect(flash[:warning]).to eq 'You do not have access to that project'
        expect(response).to redirect_to projects_path
      end

      it 'should redirect a member who is not an owner or admin to projects path' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        membership = create_membership(project_id: project.id, user_id: user.id, role: 'Member')

        expect {
          patch :update, project_id: project.id, id: membership.id, membership: { role: 'Owner'}
        }.to_not change { membership.reload.role }

        expect(flash[:warning]).to eq 'You do not have access'
        expect(response).to redirect_to projects_path
      end

      it 'should redirects non logged in users to sign in path' do
        membership = create_membership
        project = create_project

        expect {
          patch :update, project_id: project.id, id: membership.id, membership: { role: 'Owner', user_id: create_user.id , project_id: create_project.id }
        }.to_not change { membership.reload.role }

        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end

      it 'should not allow updates if there is only one owner' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        membership = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')

        expect {
          patch :update, project_id: project.id, id: membership.id, membership: { role: 'Member' }
        }.to_not change { membership.reload.role }

        expect(flash[:warning]).to eq 'Projects must have at least one owner'
        expect(response).to redirect_to project_memberships_path(project)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete a membership if current user is admin and redirects to project_memberships_path' do
      user = create_user(admin: true)
      session[:user_id] = user.id
      user2 = create_user
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user2.id, role: 'Member')

      expect {
        delete :destroy, project_id: project.id, id: membership.id
      }.to change { Membership.all.count }.by(-1)

      expect(flash[:notice]).to eq "#{membership.user.full_name} was successfully removed"
      expect(response).to redirect_to project_memberships_path(project)
    end

    it 'should delete a membership if current user is Owner and redirects to project_memberships_path' do
      user = create_user
      session[:user_id] = user.id
      user2 = create_user
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')
      membership2 = create_membership(project_id: project.id, user_id: user2.id, role: 'Member')

      expect {
        delete :destroy, project_id: project.id, id: membership2.id
      }.to change { Membership.all.count }.by(-1)

      expect(flash[:notice]).to eq "#{membership.user.full_name} was successfully removed"
      expect(response).to redirect_to project_memberships_path(project)
    end

    it 'should delete a membership if current user is self and redirects to projects path' do
      user = create_user
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'Member')

      expect {
        delete :destroy, project_id: project.id, id: membership.id
      }.to change { Membership.all.count }.by(-1)

      expect(flash[:notice]).to eq "#{membership.user.full_name} was successfully removed"
      expect(response).to redirect_to projects_path
    end

    describe 'Permissions' do
      it 'should redirect a nonmember to projects path' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        user2 = create_user
        membership = create_membership(project_id: project.id, user_id: user2.id)

        expect {
          delete :destroy, project_id: project.id, id: membership.id
        }.to_not change { Membership.all.count }
        expect(flash[:warning]).to eq 'You do not have access to that project'
        expect(response).to redirect_to projects_path
      end

      it 'should redirect a member who is not an owner or admin or self to projects path' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        user2 = create_user
        membership = create_membership(project_id: project.id, user_id: user.id, role: 'Member')
        membership2 = create_membership(project_id: project.id, user_id: user2.id, role: 'Member')

        expect {
          delete :destroy, project_id: project.id, id: membership2.id
        }.to_not change { Membership.all.count }

        expect(flash[:warning]).to eq 'You do not have access'
        expect(response).to redirect_to projects_path
      end

      it 'should redirects non logged in users to sign in path' do
        membership = create_membership
        project = create_project

        expect {
          delete :destroy, project_id: project.id, id: membership.id
        }.to_not change { Membership.all.count }

        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end

      it 'should not allow updates if there is only one owner' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        membership = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')

        expect {
          delete :destroy, project_id: project.id, id: membership.id
        }.to_not change { Membership.all.count }

        expect(flash[:warning]).to eq 'Projects must have at least one owner'
        expect(response).to redirect_to project_memberships_path(project)
      end
    end
  end
end
