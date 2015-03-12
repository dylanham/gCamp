class Task < ActiveRecord::Base
  belongs_to :project
  has_many :comments, dependent: :destroy
  validates :description, presence: true
end
