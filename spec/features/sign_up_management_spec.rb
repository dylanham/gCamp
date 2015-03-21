require 'rails_helper'

feature 'User should be able to log into gCamp and do things' do

  scenario 'should be able to login to gCamp from the welcome page' do
    visit root_path
    click_on 'Sign Up'
    fill_in 'First Name', with: 'First'
    fill_in 'Last Name', with: 'Last'
    fill_in 'Email', with: 'firstlast@example.com'
    fill_in 'Password', with: 'test'
    fill_in 'Password Confirmation', with: 'test'
    within '.form' do
      click_on 'Sign Up'
    end
    within '.alert-success' do
      expect(page).to have_content 'You have successfully signed up'
    end
  end

  scenario 'should redirect you to the root path when signing up' do
    visit root_path
    click_on 'Sign Up'
    fill_in 'First Name', with: 'First'
    fill_in 'Last Name', with: 'Last'
    fill_in 'Email', with: 'firstlast@example.com'
    fill_in 'Password', with: 'test'
    fill_in 'Password Confirmation', with: 'test'
    within '.form' do
      click_on 'Sign Up'
    end
    expect(current_path).to eq(new_project_path)
  end

  scenario 'should see validation messages when trying to sign up with with missing information' do
    visit root_path
    click_on 'Sign Up'
    within '.form' do
      click_on 'Sign Up'
    end
    expect(current_path).to eq(sign_up_path)
    expect(page).to have_content 'First name can\'t be blank'
    expect(page).to have_content 'Last name can\'t be blank'
    expect(page).to have_content 'Email can\'t be blank'
    expect(page).to have_content 'Password can\'t be blank'
  end

end
