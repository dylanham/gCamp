require 'rails_helper'

feature 'A member of a project user should be able to go crud tasks' do

  before do
    user = create_user
    @project = create_project
    @project.memberships.create!(user_id: user.id, role: 'Member')
    visit root_path
    click_on 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    within '.form' do
      click_on 'Sign In'
    end
  end

  scenario 'checks to see if can find Tasks in the header' do
    visit project_tasks_path(@project)
    within '.page-header' do
      expect(page).to have_content 'Tasks'
    end
  end

  scenario 'should be able to make a new task' do
    visit project_tasks_path(@project)
    click_on 'New Task'
    fill_in 'Description', with: 'Do Work'
    fill_in 'Due date', with: '09172016'
    click_on 'Create Task'
    within '.alert-success' do
      expect(page).to have_content 'Task was successfully created'
    end
    expect(page).to have_content 'Do Work'
    within '.breadcrumb' do
      click_on 'Task'
    end
    expect(page).to have_content 'Do Work'
  end

  scenario 'should not be able to make a blank task' do
    visit project_tasks_path(@project)
    click_on 'New Task'
    click_on 'Create'
    within '.alert-danger' do
      expect(page).to have_content '1 error prohibited this form from being saved:'
      expect(page).to have_content 'Description can\'t be blank'
    end
  end

  scenario 'should be able to update a task' do
    visit project_tasks_path(@project)
    click_on 'New Task'
    fill_in 'Description', with: 'Do Work'
    fill_in 'Due date', with: '09172016'
    click_on 'Create Task'
    expect(page).to have_content 'Do Work'
    click_on 'Edit'
    fill_in 'Description', with: 'This test has been updated'
    click_on 'Update Task'
    within '.alert-success' do
      expect(page).to have_content 'Task was successfully updated'
    end
    expect(page).to have_no_content 'This is a test'
    expect(page).to have_content ' This test has been updated'
  end

  scenario 'should be able to delete a task' do
    visit project_tasks_path(@project)
    click_on 'New Task'
    fill_in 'Description', with: 'Do Work'
    fill_in 'Due date', with: '09172016'
    click_on 'Create Task'
    expect(page).to have_content 'Do Work'
    expect(page).to have_content 'Do Work'
    visit project_tasks_path(@project)
    find('.glyphicon-remove').click
    expect(page).to have_no_content 'Do Work'
  end

  scenario 'should see an error if not logged in' do
    project = create_project
    User.destroy_all
    visit project_tasks_path(project)
    expect(current_path).to eq(sign_in_path)
    expect(page).to have_content 'You must sign in'
  end

end
