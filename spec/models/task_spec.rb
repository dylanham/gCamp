require 'rails_helper'

describe Task do

  it 'should not be valid without a description' do
    task = Task.create(description: nil)
    expect(task).to be_invalid
  end

  it 'should have a description' do
    task = Task.create!(description: 'Test with capybara and rspec')
    expect(task).to be_valid
    expect(task.description).to eq('Test with capybara and rspec')
  end

end
