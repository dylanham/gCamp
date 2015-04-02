
require 'rails_helper'

describe Private::ProjectsController do
  describe 'GET #index' do
    it 'should have list of the current users project objects' do
      user = create_user
      session[:user_id] = user.id
      project = create_project
      project2 = create_project
      membership = create_membership(project_id: project.id, user_id: user.id)

      get :index

      expect(assigns(:projects)).to eq [project]
    end

    it 'should have a list of all projects for admins' do
      user = create_user(admin: true)
      session[:user_id] = user.id
      project = create_project
      project2 = create_project
      project3 = create_project

      get :index
      expect(assigns(:admin_projects)).to eq [project, project2, project3]
    end

    it 'should render the index view' do
      user = create_user
      session[:user_id] = user.id

      get :index

      expect(response).to render_template :index
    end

    describe 'permissions' do
      it 'should redirects non logged in users to sign in path' do

        get :index

        expect(session[:return_to]).to eq projects_path
        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe 'GET #show' do
    it 'should have a project object' do
      user = create_user(admin: true)
      session[:user_id] = user.id
      project = create_project

      get :show, id: project.id

      expect(assigns(:project)).to be_a(Project)
    end

    it 'should render a template for show' do
      user = create_user(admin: true)
      session[:user_id] = user.id
      project = create_project

      get :show, id: project.id

      expect(response).to render_template :show
    end

    describe 'Permissions' do
      it 'should redirect a non logged in user' do
        project = create_project

        get :show, id: project.id

        expect(session[:return_to]).to eq project_path(project)
        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end
      it 'should redirect a non member to projects path' do
        user = create_user
        session[:user_id] = user.id
        project = create_project

        get :show, id: project.id

        expect(flash[:warning]).to eq 'You do not have access to that project'
        expect(response).to redirect_to projects_path
      end
    end
  end

  describe 'Get #new' do
    it 'should have a new object for any logged in user' do
      user = create_user
      session[:user_id] = user.id

      get :new

      expect(assigns(:project)).to be_a_new(Project)
    end

    it 'should render the new view for any logged in user' do
      user = create_user
      session[:user_id] = user.id

      get :new

      expect(response).to render_template :new
    end
    describe 'Permissions' do
      it 'should redirect a non logged in user to sign in' do
        get :new

        expect(session[:return_to]).to eq new_project_path
        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe 'Post #create' do
    describe 'On success' do
      it 'creates a new project when valid params are passed and sets current user as owner' do
        user = create_user
        session[:user_id] = user.id

        expect {
          post :create, project: { name: 'Test Project' }
        }.to change { Project.all.count }.by(1)

        expect(flash[:notice]).to eq 'Project was successfully created'
        expect(user.memberships.last.role).to eq 'Owner'
        expect(response).to redirect_to project_tasks_path(user.projects.last)
      end
    end

    describe 'On failure when invalid params are passed' do
      it 'should not make a new object' do
        user = create_user
        session[:user_id] = user.id

        expect {
          post :create, project: {name: nil}
        }.to_not change { Project.all.count}

        expect(assigns(:project)).to be_a(Project)
        expect(response).to render_template :new
      end
    end

    describe 'Permissions' do
      it 'redirects a non logged in user to sign up path' do
        user = create_user

        expect {
          post :create, project: { name: 'Test' }
        }.to_not change { Project.all.count}

        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe 'GET #edit' do
    it 'should have a project item for an admin and render the edit view' do
      user = create_user(admin: true)
      session[:user_id] = user.id
      project = create_project

      get :edit, id: project.id

      expect(assigns(:project)).to eq project
      expect(response).to render_template :edit
    end
    it 'should have a project item for an owner and render the edit view' do
      user = create_user
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(user_id: user.id, project_id: project.id, role: 'Owner')

      get :edit, id: project.id

      expect(assigns(:project)).to eq project
      expect(response).to render_template :edit
    end
    describe 'Permissions' do
      it 'should redirect a non logged in user to sign up' do
        project = create_project

        get :edit, id: project.id

        expect(session[:return_to]).to eq edit_project_path(project)
        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end

      it 'should redirect a non member to projects path' do
        user = create_user
        project = create_project
        session[:user_id] = user.id

        get :edit, id: project.id

        expect(flash[:warning]).to eq 'You do not have access to that project'
        expect(response).to redirect_to projects_path
      end

      it 'should redirect a member that is not an owner or admin to projects path' do
        user = create_user
        project = create_project
        membership = create_membership(project_id: project.id, user_id: user.id)
        session[:user_id] = user.id

        get :edit, id: project.id

        expect(flash[:warning]).to eq 'You do not have access'
        expect(response).to redirect_to projects_path
      end
    end
  end

  describe 'PATCH #update' do
    describe 'On success' do
      it 'should update a project for an admin when valid params are passed' do
        user = create_user(admin: true)
        session[:user_id] = user.id
        project = create_project

        expect {
          patch :update, id: project.id, project:{name: 'Updated Name'}
        }.to change { project.reload.name }.from('Test Project').to('Updated Name')

        expect(flash[:notice]).to eq 'Project was successfully updated'
        expect(response).to redirect_to project_path(project)
      end

      it 'should update a project for an owner when valid params are passed' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        membership = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')

        expect {
          patch :update, id: project.id, project:{ name: 'Update Name' }
        }.to change { project.reload.name }.from('Test Project').to('Update Name')

        expect(flash[:notice]).to eq 'Project was successfully updated'
        expect(response).to redirect_to project_path(project)
      end
    end

    describe 'On failure' do
      it 'should not update a project when valid params are not passed' do
        user = create_user(admin: true)
        session[:user_id] = user.id
        project = create_project

        expect {
          patch :update, id: project.id, project: { name: nil }
        }.to_not change { project.reload.name }

        expect(assigns(:project)).to eq(project)
        expect(response).to render_template :edit
      end
    end

    describe 'Permissions' do
      it 'should redirect a non logged in user to sign up' do
        project = create_project

        get :update, id: project.id

        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end

      it 'should redirect a non member to projects path' do
        user = create_user
        project = create_project
        session[:user_id] = user.id

        get :update, id: project.id

        expect(flash[:warning]).to eq 'You do not have access to that project'
        expect(response).to redirect_to projects_path
      end

      it 'should redirect a member that is not an owner or admin to projects path' do
        user = create_user
        project = create_project
        membership = create_membership(project_id: project.id, user_id: user.id)
        session[:user_id] = user.id

        get :update, id: project.id

        expect(flash[:warning]).to eq 'You do not have access'
        expect(response).to redirect_to projects_path
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete a project if current user is an admin as well as its memberships' do
      user = create_user(admin: true)
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id)

      expect {
        delete :destroy, id: project.id
      }.to change { Project.all.count }.by(-1)

      expect(flash[:notice]).to eq 'Project was successfully deleted'
      expect(Membership.all.count).to eq 0
      expect(response).to redirect_to projects_path
    end

    it 'should delete a project if current user is an owner as well as its memberships' do
      user = create_user
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')

      expect {
        delete :destroy, id: project.id
      }.to change { Project.all.count }.by(-1)

      expect(flash[:notice]).to eq 'Project was successfully deleted'
      expect(Membership.all.count).to eq 0
      expect(response).to redirect_to projects_path
    end

    describe 'Permissions' do
      it 'should redirect a non logged in user to sign up' do
        project = create_project

        delete :destroy, id: project.id

        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end

      it 'should redirect a non member to projects path' do
        user = create_user
        project = create_project
        session[:user_id] = user.id

        delete :destroy, id: project.id

        expect(flash[:warning]).to eq 'You do not have access to that project'
        expect(response).to redirect_to projects_path
      end

      it 'should redirect a member that is not an owner or admin to projects path' do
        user = create_user
        project = create_project
        membership = create_membership(project_id: project.id, user_id: user.id)
        session[:user_id] = user.id

        delete :destroy, id: project.id

        expect(flash[:warning]).to eq 'You do not have access'
        expect(response).to redirect_to projects_path
      end
    end
  end
end
