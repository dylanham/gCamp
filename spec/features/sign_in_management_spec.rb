require 'rails_helper'

feature 'Users should be able to sign in' do

  before :each do
    @user = create_user
  end

  it 'should be able to click sign in then sign in' do
    visit root_path
    click_on 'Sign In'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    within '.form' do
      click_on 'Sign In'
    end
    within '.alert-success' do
      expect(page).to have_content 'You have successfully signed in'
    end
  end

  it 'should see an error if signing in with bad information' do
    visit root_path
    click_on 'Sign In'
    fill_in 'Email', with: 'wrong@example.com'
    fill_in 'Password', with: 'wrong'
    within '.form' do
      click_on 'Sign In'
    end
    expect(page).to have_content 'Email / Password combination is invalid'
  end

  it 'should be able routed to root page after signing in' do
    visit faq_path
    click_on 'Sign In'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    within '.form' do
      click_on 'Sign In'
    end
    expect(current_path).to eq(root_path)
  end

end
