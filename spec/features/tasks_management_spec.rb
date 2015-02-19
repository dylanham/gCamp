require 'rails_helper'
feature 'user should be able to go to index page and see something' do
  it 'checks to see if it can find the word Users' do
    visit tasks_path
    save_and_open_page
    expect(page).to have_content 'Tasks'
  end
  it 'should be able to make a new tak' do
    visit tasks_path
    click_on 'New Task'
    fill_in 'Description', with: 'Do Work'
    fill_in 'Due date', with: '09172016'
    click_on 'Create'
    within '.breadcrumb' do
    click_on 'Task'
    expect(page).to have_content 'Do Work'
    save_and_open_page
    end
  end
end
