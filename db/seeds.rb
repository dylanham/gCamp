# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

  # some first user last user@example.com password password

100.times do
  Membership.create!(role: 'Member',project_id: nil, user_id: nil)
end

100.times do
  User.create!(
    first_name: "Some#{rand(100)+1}",
    last_name: "User#{rand(100)+1}",
    email: "user#{rand(100)+1}@xample.com",
    password: 'password'
  )
end

100.times do
  Task.create!(description: "A task",project_id: rand(100)+1)
end

100.times do
  Comment.create!(content: "A comment", task_id: rand(100)+1, user_id: rand(100)+1)
end

100.times do
  Comment.create!(content: "A comment with a task but no user should be (deleted user)", task_id: 888, user_id: rand(100)+1)
end

100.times do
  Task.create!(description: "A Task without a project_id", project_id: nil)
end

100.times do
  Comment.create!(content: "A comment without a task", task_id: nil)
end
