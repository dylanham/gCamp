require 'rails_helper'

describe Task do

  it 'should not be valid without a description' do
    task = Task.create(description: nil)
    expect(task).to be_invalid
    expect(task.errors[:description]).to include("can't be blank")
  end

  it 'should have a description' do
    task = Task.create!(description: 'Test with capybara and rspec')
    expect(task).to be_valid
    expect(task.description).to eq('Test with capybara and rspec')
  end

end
