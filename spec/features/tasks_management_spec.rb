require 'rails_helper'
describe 'user should be able to go to index page and see something' do
  it 'checks to see if it can find the word Users' do
    visit users_path
    save_and_open_page
    expect(page).to have_content 'Users'
  end
  it 'should be able to click the New User Button' do
    visit users_path
    save_and_open_page
    expect(page).to click_button('New User')
  end
end
