class CreateTasksTable < ActiveRecord::Migration
  def change
    create_table :tasks_tables do |t|
      t.string :description
    end
  end
end
