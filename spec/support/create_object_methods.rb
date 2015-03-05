def create_user(options = {})
  User.create!({
    first_name: 'billy',
    last_name: 'bob',
    email: 'billybob@example.com',
    password: 'test'
  }.merge(options))
end

def create_project(options = {})
  Project.create!({
    name: 'Test Project'
  }.merge(options))
end

def create_task(project, options = {})
  Task.create!({
    description: 'Test task for a project',
    project_id: project.id,
    complete: true,
  }.merge(options))
end
