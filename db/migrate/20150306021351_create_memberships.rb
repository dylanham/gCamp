class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.string :role
      t.integer :user_id
      t.integer :projects_id

      t.timestamps null: false
    end
  end
end
