namespace :cleanup do
  desc 'Removes all memberships where their users have already been deleted'
  task list: :environment do
    puts "-"* 100
    remove_these = Membership.where.not(user_id: User.pluck(:id)).delete_all
    puts "| #{remove_these} memberships where their users have already been deleted were removed"
  end

  desc 'Removes all memberships where their projects have already been deleted'
  task list: :environment do
    remove_these = Membership.where.not(project_id: Project.pluck(:id)).delete_all
    puts "| #{remove_these} memberships where their projects have already been deleted were removed"

  end

  desc 'Removes all tasks where their projects have been deleted'
  task list: :environment do
    remove_these = Task.where.not(project_id: Project.pluck(:id)).delete_all
    puts "| #{remove_these} tasks where their projects have been deleted were removed"
  end

  desc 'Removes all comments where their tasks have been deleted'
  task list: :environment do
    remove_these = Comment.where.not(task_id: Task.pluck(:id)).delete_all
    puts "| #{remove_these} comments where their tasks have been deleted were removed"
  end

  desc 'Sets the user_id of comments to nil if their users have been deleted'
  task list: :environment do
    update_these = Comment.where.not(user_id: User.pluck(:id)).update_all(user_id: nil)
    puts "| #{update_these} user_id's of comments were set to nil because their users have been deleted"
  end

  desc 'Removes any tasks with null project_id'
  task list: :environment do
    remove_these = Task.where(project_id: nil).delete_all
    puts "| #{remove_these} tasks were removed that had a null project_id"
  end

  desc 'Removes any comments with a null task_id'
  task list: :environment do
    remove_these = Comment.where(task_id: nil).delete_all
    puts "| #{remove_these} comments were removed that had a null task_id"
  end

  desc 'Removes any memberships with a null project_id or user_id'
  task list: :environment do
    remove_these = Membership.where("project_id IS ? OR user_id IS ?",nil,nil ).delete_all
    puts "| #{remove_these} memberships were removed that had either a null project_id or user_id"
    puts "-"* 100
  end

end
