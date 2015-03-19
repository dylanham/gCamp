require 'rails_helper'

describe Project do

  it 'should have a name' do
    project = Project.create!(name: 'Test')
    expect(project).to be_valid
  end

  it 'should be invalid without a name' do
    project = Project.create(name: nil)
    expect(project).to be_invalid
  end

end
 
