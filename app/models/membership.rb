class Membership < ActiveRecord::Base
  ROLES = ['Member', 'Owner']

  validates :role, inclusion: ROLES
  validates :user, presence: true
  validates_uniqueness_of :user, scope: :project, message: "has already been added to this project"

  belongs_to :user
  belongs_to :project
end
