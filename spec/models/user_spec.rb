require 'rails_helper'

describe User do

  before :each do
    User.destroy_all
    @user = User.create(first_name: 'First', last_name: 'Last', email: 'firstlast@test.com', password: 'test')
  end

  it 'should have a first_name' do
    @user.first_name = 'Test'
    expect(@user).to be_valid
    expect(@user.first_name).to eq('Test')
  end

  it 'should have a last_name' do
    @user.last_name = 'Test'
    expect(@user).to be_valid
    expect(@user.last_name).to eq('Test')
  end

  it 'should have an email' do
    @user.email = 'test@test.com'
    expect(@user).to be_valid
    expect(@user.email).to eq('test@test.com')
  end

  it 'should have a password' do
    @user.password = 'test123'
    expect(@user).to be_valid
    expect(@user.password).to eq('test123')
  end

  it 'should have a full_name' do
    expect(@user).to be_valid
    expect(@user.full_name).to eq('First Last')
  end

  it 'should have a unique email' do
    @user.email = "new@new.com"
    expect(@user).to be_valid
  end

  it 'should be invalid if user email is not unique' do
    user = User.create(first_name: 'first_test', last_name: 'last_test', email: 'firstlast@test.com')
    expect(user).to be_invalid
  end

  it 'should be invalid if it does not have a first_name' do
    @user.first_name = nil
    expect(@user).to be_invalid
  end

  it 'should be invalid if it does not have a last_name' do
    @user.last_name = nil
    expect(@user).to be_invalid
  end

  it 'should be invalid if it does not have a first_name' do
    @user.email = nil
    expect(@user).to be_invalid
  end

  it 'should be invalid if it does not have a first_name' do
    @user.password = nil
    expect(@user).to be_invalid
  end

end
