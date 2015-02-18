require 'rails_helper'
describe 'user should be able to go to index page and see something' do
  it 'checks to see if it can find the word Users' do
    visit tasks_path
    save_and_open_page
    expect(page).to have_content 'Tasks'
  end
  it 'should be able to click the New Task Button' do
    visit tasks_path
    save_and_open_page
    click_link 'New Task'
  end
end
