require 'rails_helper'

describe TermsController do
  describe 'GET #index' do
    it 'renders the index view' do
      get :index

      expect(response).to render_template(:index)
    end
  end

  describe 'GET #about_page' do
    it 'renders the about_page view' do
      get :about_page

      expect(response).to render_template(:about_page)
    end

    it 'has a list of all project objects' do
      project = create_project

      get :about_page
      expect(assigns(:projects)).to eq [project]
    end

    it 'has a list of all user objects' do
      user = create_user

      get :about_page

      expect(assigns(:users)).to eq [user]
    end

    it 'has a list of all comment objects' do
      comment = create_comment

      get :about_page

      expect(assigns(:comments)).to eq [comment]
    end

    it 'has a list of all membership objects' do
      membership = create_membership

      get :about_page

      expect(assigns(:memberships)).to eq [membership]
    end
    it 'has a list of all task objects' do
      task = create_task

      get :about_page

      expect(assigns(:tasks)).to eq [task]
    end
  end
end
