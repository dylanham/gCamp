class Membership < ActiveRecord::Base
  ROLES = ['Member', 'User']
  validates :user, presence: true
  belongs_to :user
  belongs_to :project
end
