require 'rails_helper'

feature 'user should be able to go to index page and see something' do

  before :each do
    User.destroy_all
    user = create_user
    visit root_path
    click_on 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    within '.form' do
      click_on 'Sign In'
    end
  end

  it 'checks to see if it can find New Task' do
    visit tasks_path
    expect(page).to have_content 'New Task'
  end

  it 'should be able to make a new task' do
    visit tasks_path
    click_on 'New Task'
    fill_in 'Description', with: 'Do Work'
    fill_in 'Due date', with: '09172016'
    click_on 'Create'
    within '.breadcrumb' do
      click_on 'Task'
    end
    expect(page).to have_content 'Do Work'
  end

  it 'should be able to update a task' do
    Task.create!(description: 'This is a test', due_date: '09172016')
    visit tasks_path
    expect(page).to have_content 'This is a test'
    click_on 'Edit'
    fill_in 'Description', with: 'This test has been updated'
    click_on 'Update Task'
    expect(page).to have_no_content 'This is a test'
    expect(page).to have_content ' This test has been updated'
  end

  it 'should be able to delete a task' do
    Task.create!(description: 'This is a test', due_date: '09172016')
    visit tasks_path
    expect(page).to have_content 'This is a test'
    click_on 'Delete'
    expect(page).to have_no_content 'This is a test'
  end

  it 'should be able to visit the show page of a task' do
    Task.create!(description: 'This is a test', due_date: '09172016')
    visit tasks_path
    click_on 'This is a test'
    within '.breadcrumb' do
      expect(page).to have_content 'This is a test'
    end
  end

  it 'should see an error if not logged in' do
    User.destroy_all
    visit tasks_path
    expect(page).to have_content 'You must sign in'
  end

end
