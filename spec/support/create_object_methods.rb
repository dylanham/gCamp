def create_user(options = {})
  User.create!({
    first_name: 'billy',
    last_name: 'bob',
    email: 'billybob@example.com',
    password: 'test'
  }.merge(options))
end
