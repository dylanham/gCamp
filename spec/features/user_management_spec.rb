require 'rails_helper'

feature 'User should be able to crud users' do
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

  it 'should be able to visit the index page of users and see Users' do
    visit users_path
    within '.page-header' do
      expect(page).to have_content 'Users'
    end
  end

  it 'should not be able to visit users pages without being logged in' do
    User.destroy_all
    visit users_path
    expect(current_path).to eq(sign_in_path)
    expect(page).to have_content 'You must sign in'
  end

  it 'should be able to create a new user' do
    visit users_path
    click_on 'New User'
    fill_in 'First Name', with: 'New'
    fill_in 'Last Name', with: 'User'
    fill_in 'Email', with: 'newuser@example.com'
    fill_in 'Password', with: '1234'
    fill_in 'Password Confirmation', with: '1234'
    click_on 'Create User'
    expect(current_path).to eq(users_path)
    expect(page).to have_content 'User was successfully created'
    expect(page).to have_content 'newuser@example.com'
  end

  it 'should be able to update a new user' do
    visit users_path
    click_on 'Edit'
    fill_in 'First Name', with: 'New First Name'
    click_on 'Update User'
    expect(current_path).to eq(users_path)
    expect(page).to have_content 'User was successfully updated'
    expect(page).to have_content 'New First Name'
  end

  it 'should be able to delete a user' do
    user2 = create_user(email: 'second@example.com')
    visit edit_user_path(user2)
    click_on 'Delete User'
    expect(current_path).to eq(users_path)
    expect(page).to have_content 'User was successfully delete'
    expect(page).to have_no_content 'second@example.com'
  end


end
