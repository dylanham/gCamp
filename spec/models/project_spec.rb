require 'rails_helper'

describe Project do
  it 'should have a name' do
    project = Project.create(name: 'Test')
    expect(project).to be_valid
  end
  
end
