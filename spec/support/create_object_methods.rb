def create_user(options = {})
  User.create!({
    first_name: 'billy',
    last_name: 'bob',
    email: "billybob#{rand(10000)+1}@example.com",
    password: 'test'
  }.merge(options))
end

def create_project(options = {})
  Project.create!({
    name: 'Test Project'
  }.merge(options))
end

def create_task(options = {})
  Task.create!({
    description: 'Test task for a project',
    project_id: create_project.id,
    complete: true,
  }.merge(options))
end

def create_comment(options = {})
  Comment.create!({
    content: 'A Book',
    user_id: create_user.id,
    task_id: create_task.id
  }.merge(options))
end

def create_membership(options = {})
  Membership.create!({
    role: "Member",
    user_id: create_user.id,
    project_id: create_project.id
  }.merge(options))
end
