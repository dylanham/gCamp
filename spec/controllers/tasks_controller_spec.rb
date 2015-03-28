require 'rails_helper'

describe Private::TasksController do
  describe 'GET #index' do
    it 'should have a list of all tasks for a project and render the index view for an admin' do
      user = create_user(admin: true)
      session[:user_id] = user.id
      project = create_project
      task = create_task(project_id: project.id)

      get :index, project_id: project.id

      expect(assigns(:tasks)).to eq [task]
      expect(response).to render_template :index
    end

    it 'should have a list of all tasks for a project and render the index view for a member' do
      user = create_user
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(user_id: user.id, project_id: project.id, role: 'Member')
      task = create_task(project_id: project.id)

      get :index, project_id: project.id

      expect(assigns(:tasks)).to eq [task]
      expect(response).to render_template :index
    end

    it 'should have a list of all tasks for a project and render the index view for an Owner' do
      user = create_user
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(user_id: user.id, project_id: project.id, role: 'Owner')
      task = create_task(project_id: project.id)

      get :index, project_id: project.id

      expect(assigns(:tasks)).to eq [task]
      expect(response).to render_template :index
    end

    describe 'Permissions'do
      it 'should redirect a non logged in user to sign up' do
        project = create_project

        get :index, project_id: project.id

        expect(session[:return_to]).to eq project_tasks_path(project)
        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end

      it 'should redirect a non member to projects path' do
        user = create_user
        project = create_project
        membership = create_membership(user_id: user.id)
        session[:user_id] = user.id

        get :index, project_id: project.id

        expect(flash[:warning]).to eq 'You do not have access to that project'
        expect(response).to redirect_to projects_path
      end
    end
  end

  describe 'GET #show' do
    it 'should have a task as well as render the shoe view for an admin' do
      user = create_user(admin: true)
      session[:user_id] = user.id
      project = create_project
      task = create_task(project_id: project.id)

      get :show, project_id: project.id, id: task.id

      expect(assigns(:project)).to eq project
      expect(response).to render_template :show
    end

    it 'should have a task as well as render the show view for an Owner' do
      user = create_user
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')
      task = create_task(project_id: project.id)

      get :show, project_id: project.id, id: task.id

      expect(assigns(:project)).to eq project
      expect(response).to render_template :show
    end

    it 'should have a task as well as render the show view for a member' do
      user = create_user
      session[:user_id] = user.id
      project = create_project
      task = create_task(project_id: project.id)
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'Member')

      get :show, project_id: project.id, id: task.id

      expect(assigns(:project)).to eq project
      expect(response).to render_template :show
    end

    describe 'Permissions' do
      it 'should redirect a non logged in user to sign up' do
        project = create_project
        task = create_task(project_id: project.id)

        get :show, project_id: project.id, id: task.id

        expect(session[:return_to]).to eq project_task_path(project, task)
        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end

      it 'should redirect a non member to projects path' do
        user = create_user
        project = create_project
        task = create_task(project_id: project.id)
        membership = create_membership(user_id: user.id)
        session[:user_id] = user.id

        get :show, project_id: project.id, id: task.id

        expect(flash[:warning]).to eq 'You do not have access to that project'
        expect(response).to redirect_to projects_path
      end
    end
  end

  describe 'GET #new' do
    it 'should have a new task object and render the new view for an admin' do
      user = create_user(admin: true)
      project = create_project
      task = create_task(project_id: project.id)
      session[:user_id] = user.id

      get :new, project_id: project.id

      expect(assigns(:task)).to be_a_new(Task)
      expect(response).to render_template :new
    end

    it 'should have a new task object and render the new view for a member' do
      user = create_user
      project = create_project
      task = create_task(project_id: project.id)
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'Member')
      session[:user_id] = user.id

      get :new, project_id: project.id

      expect(assigns(:task)).to be_a_new(Task)
      expect(response).to render_template :new
    end

    it 'should have a new task object and render the new view for an Owner' do
      user = create_user
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')
      session[:user_id] = user.id

      get :new, project_id: project.id

      expect(assigns(:task)).to be_a_new(Task)
      expect(response).to render_template :new
    end

    describe 'Permissions' do
      it 'should redirect a non logged in user to sign up' do
        project = create_project

        get :new, project_id: project.id

        expect(session[:return_to]).to eq new_project_task_path(project)
        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end

      it 'should redirect a non member to projects path' do
        user = create_user
        project = create_project
        membership = create_membership(user_id: user.id)
        session[:user_id] = user.id

        get :new, project_id: project.id

        expect(flash[:warning]).to eq 'You do not have access to that project'
        expect(response).to redirect_to projects_path
      end
    end
  end

  describe 'POST #create' do
    describe 'On success' do
      it 'creates a new task when valid params are passed for an admin' do
        user = create_user(admin: true)
        project = create_project
        session[:user_id] = user.id

        expect {
          post :create, project_id: project.id, task: { description: 'Test Task' }
        }.to change { Task.all.count }.by(1)

        expect(flash[:notice]).to eq 'Task was successfully created'
        expect(project.tasks.last.description).to eq 'Test Task'
        expect(response).to redirect_to project_task_path(project, project.tasks.last)
      end

      it 'creates a new task when valid params are passed for an owner' do
        user = create_user
        project = create_project
        membership = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')
        session[:user_id] = user.id

        expect{
          post :create, project_id: project.id, task: { description: 'Test Task' }
        }.to change { Task.all.count }.by(1)

        expect(flash[:notice]).to eq 'Task was successfully created'
        expect(project.tasks.last.description).to eq 'Test Task'
        expect(response).to redirect_to project_task_path(project, project.tasks.last)
      end

      it 'creates a new task when valid params are passed for a member' do
        user = create_user
        project = create_project
        membership = create_membership(project_id: project.id, user_id: user.id, role: 'Member')
        session[:user_id] = user.id

        expect{
          post :create, project_id: project.id, task: { description: 'Test Task' }
        }.to change { Task.all.count }.by(1)

        expect(flash[:notice]).to eq 'Task was successfully created'
        expect(project.tasks.last.description).to eq 'Test Task'
        expect(response).to redirect_to project_task_path(project, project.tasks.last)
      end
    end

    describe 'On failure' do
      it 'should not create a new task when invalid params are passed for an admin' do
        user = create_user(admin: true)
        session[:user_id] = user.id
        project = create_project

        expect{
          post :create, project_id: project.id, task: { description: nil }
        }.to_not change { Task.all.count }

        expect(assigns(:task)).to be_a_new(Task)
        expect(response).to render_template :new
      end

      it 'should not create a new task when invalid params are passed for an Owner' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        membership = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')

        expect{
          post :create, project_id: project.id, task: { description: nil }
        }.to_not change { Task.all.count }

        expect(assigns(:task)).to be_a_new(Task)
        expect(response).to render_template :new
      end

      it 'should not create a new task when invalid params are passed for an Member' do
        user = create_user
        session[:user_id] = user.id
        project = create_project
        membership = create_membership(project_id: project.id, user_id: user.id, role: 'Member')

        expect{
          post :create, project_id: project.id, task: { description: nil }
        }.to_not change { Task.all.count }

        expect(assigns(:task)).to be_a_new(Task)
        expect(response).to render_template :new
      end
    end
  end

  describe 'Permissions' do
    it 'should redirect a non logged in user to sign up' do
      project = create_project

      post :create, project_id: project.id

      expect(flash[:warning]).to eq 'You must sign in'
      expect(response).to redirect_to sign_in_path
    end

    it 'should redirect a non member to projects path' do
      user = create_user
      project = create_project
      membership = create_membership(user_id: user.id)
      session[:user_id] = user.id

      post :create, project_id: project.id

      expect(flash[:warning]).to eq 'You do not have access to that project'
      expect(response).to redirect_to projects_path
    end
  end

  describe 'GET #edit' do
    it 'should render the edit view for a task for an Admin' do
      user = create_user(admin: true)
      project = create_project
      task = create_task(project_id: project.id)
      session[:user_id] = user.id

      get :edit, project_id: project.id, id: task.id

      expect(response).to render_template :edit
      expect(assigns(:task)).to eq task
    end
    it 'should render the edit view for a task for an Owner' do
      user = create_user
      project = create_project
      task = create_task(project_id: project.id)
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')
      session[:user_id] = user.id

      get :edit, project_id: project.id, id: task.id

      expect(response).to render_template :edit
      expect(assigns(:task)).to eq task
    end

    describe 'Permissions' do
      it 'should redirect a non logged in user to sign up' do
        project = create_project
        task = create_task(project_id: project.id)

        get :edit, project_id: project.id, id: task.id

        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end

      it 'should redirect a non member to projects path' do
        user = create_user
        project = create_project
        task = create_task(project_id: project.id)
        membership = create_membership(user_id: user.id)
        session[:user_id] = user.id

        post :edit, project_id: project.id, id: task.id

        expect(flash[:warning]).to eq 'You do not have access to that project'
        expect(response).to redirect_to projects_path
      end
    end
  end

  describe 'PATCH #update' do
    describe 'On success' do
      it 'should update a task when valid params are passed and current user is admin' do
        user = create_user(admin: true)
        project = create_project
        task = create_task(project_id: project.id)
        session[:user_id] = user.id

        expect{
          patch :update, project_id: project.id, id: task.id, task: { description: 'Updated task description' }
        }.to change { task.reload.description }.from('Test task for a project').to('Updated task description')

        expect(flash[:notice]).to eq 'Task was successfully updated'
        expect(response).to redirect_to project_task_path(project, task)
      end

      it 'should update a task when valid params are passed and current user is owner' do
        user = create_user
        project = create_project
        task = create_task(project_id: project.id)
        membership = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')
        session[:user_id] = user.id

        expect{
          patch :update, project_id: project.id, id: task.id, task: { description: 'Updated task description' }
        }.to change { task.reload.description }.from('Test task for a project').to('Updated task description')

        expect(flash[:notice]).to eq 'Task was successfully updated'
        expect(response).to redirect_to project_task_path(project, task)
      end
    end

    describe 'On Failure' do
      it 'should not update an item for an admin when invalid params are passed' do
        user = create_user(admin: true)
        project = create_project
        task = create_task(project_id: project.id)
        session[:user_id] = user.id

        expect {
          patch :update, project_id: project.id, id: task.id, task: { description: nil }
        }.to_not change { task.reload.description }

        expect(response).to render_template :edit
      end

      it 'should not update an item for an owner when invalid params are passed' do
        user = create_user
        project = create_project
        task = create_task(project_id: project.id)
        session[:user_id] = user.id
        membership = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')

        expect {
          patch :update, project_id: project.id, id: task.id, task: { description: nil }
        }.to_not change { task.reload.description }

        expect(response).to render_template :edit
      end
    end

    describe 'Permisions' do
      it 'should redirect a non logged in user to sign up' do
        project = create_project
        task = create_task(project_id: project.id)

        patch :update, project_id: project.id, id: task.id, task: { description: 'Nope' }

        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end

      it 'should redirect a non member to projects path' do
        user = create_user
        project = create_project
        task = create_task(project_id: project.id)
        membership = create_membership(user_id: user.id)
        session[:user_id] = user.id

        patch :update, project_id: project.id, id: task.id, task: { description: 'Nope' }

        expect(flash[:warning]).to eq 'You do not have access to that project'
        expect(response).to redirect_to projects_path
      end
    end
  end
  describe 'DELETE #destroy' do
    it 'should delete a task if current user is admin' do
      user = create_user(admin: true)
      project = create_project
      task = create_task(project_id: project.id)
      session[:user_id] = user.id

      expect {
        delete :destroy, project_id: project.id, id: task.id
      }.to change { Task.all.count }.by(-1)

      expect(response).to redirect_to project_tasks_path(project)
    end

    it 'should be able to delete a task if current user is a member' do
      user = create_user
      project = create_project
      task = create_task(project_id: project.id)
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'Member')
      session[:user_id] = user.id

      expect {
        delete :destroy, project_id: project.id, id: task.id
      }.to change { Task.all.count }.by(-1)

      expect(response).to redirect_to project_tasks_path(project)
    end
    it 'should be able to delete a task if current user is a owner' do
      user = create_user
      project = create_project
      task = create_task(project_id: project.id)
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'Owner')
      session[:user_id] = user.id

      expect {
        delete :destroy, project_id: project.id, id: task.id
      }.to change { Task.all.count }.by(-1)

      expect(response).to redirect_to project_tasks_path(project)
    end
    describe 'Permisions' do
      it 'should redirect a non logged in user to sign up' do
        project = create_project
        task = create_task(project_id: project.id)

        delete :destroy, project_id: project.id, id: task.id

        expect(flash[:warning]).to eq 'You must sign in'
        expect(response).to redirect_to sign_in_path
      end

      it 'should redirect a non member to projects path' do
        user = create_user
        project = create_project
        task = create_task(project_id: project.id)
        membership = create_membership(user_id: user.id)
        session[:user_id] = user.id

        delete :destroy, project_id: project.id, id: task.id

        expect(flash[:warning]).to eq 'You do not have access to that project'
        expect(response).to redirect_to projects_path
      end
    end
  end
end
