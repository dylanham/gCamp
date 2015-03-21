require 'rails_helper'

feature 'It should have full crud access of projects' do

  before do
    User.destroy_all
    Project.destroy_all
    user = create_user
    visit root_path
    click_on 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    within '.form' do
      click_on 'Sign In'
    end
  end

  scenario 'should be able to visit projects page and see projects in the header' do
    visit projects_path
    within '.page-header' do
      expect(page).to have_content 'Projects'
    end
  end

  scenario 'should not be able to visit projects page if not logged in' do
    User.destroy_all
    visit projects_path
    expect(current_path).to eq(sign_in_path)
    expect(page).to have_content 'You must sign in'
  end

  scenario 'should be able to create a new project' do
    visit projects_path
    within '.page-header' do
      click_on 'New Project'
    end
    fill_in 'Name', with: 'Test Project'
    click_on 'Create Project'
    within '.alert-success' do
      expect(page).to have_content 'Project was successfully created'
    end
    expect(page).to have_content 'Test Project'
  end

  scenario 'should see an error if trying to create a nameless project' do
    visit projects_path
    within '.page-header' do
      click_on 'New Project'
    end
    click_on 'Create Project'
    within '.alert-danger' do
      expect(page).to have_content '1 error prohibited this form from being saved:'
      expect(page).to have_content 'Name can\'t be blank'
    end
  end

  scenario 'should be able to update a project that they own' do
    visit projects_path
    within '.page-header' do
      click_on 'New Project'
    end
    fill_in 'Name', with: 'Update Test'
    click_on 'Create Project'
    within '.breadcrumb' do
      click_on 'Update Test'
    end
    click_on 'Edit'
    fill_in 'Name', with: 'This is a test update'
    click_on 'Update Project'
    within '.alert-success' do
      expect(page).to have_content 'Project was successfully updated'
    end
    within '.page-header' do
      expect(page).to have_content 'This is a test update'
    end
  end

  scenario 'should be able to delete a project that they own' do
    visit projects_path
    within '.page-header' do
      click_on 'New Project'
    end
    fill_in 'Name', with: 'Remove Test'
    click_on 'Create Project'
    expect(page).to have_content 'Remove Test'
    within '.breadcrumb' do
      click_on 'Remove Test'
    end

    within '.well' do
      click_on 'Delete'
    end
    within '.alert-success' do
      expect(page).to have_content 'Project was successfully deleted'
    end
    expect(page).to have_no_content 'Delete Test'
  end

end
