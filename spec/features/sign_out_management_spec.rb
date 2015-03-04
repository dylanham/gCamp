require 'rails_helper'

feature 'Users should be able to sign out' do

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

   it 'should be able to click on the sign out button' do
     visit root_path
     click_on 'Sign Out'
     within '.alert-success' do
       expect(page).to have_content 'You have successfully logged out'
     end
     expect(current_path).to eq(root_path)
   end

   it 'should be able to sign out from a different page and be redirected to root' do
     visit projects_path
     click_on 'Sign Out'
     within '.alert-success' do
       expect(page).to have_content 'You have successfully logged out'
     end
     expect(current_path).to eq(root_path)
   end



 end
