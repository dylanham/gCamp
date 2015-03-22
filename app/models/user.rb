class User < ActiveRecord::Base
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true
  has_secure_password
  has_many :memberships, dependent: :destroy
  has_many :comments
  has_many :projects, through: :memberships
  def full_name
    "#{first_name} #{last_name}".titleize
  end

  def admin_or_member?(project)
    self.admin || self.memberships.find_by(project_id: project.id) != nil
  end

  def admin_or_owner?(project)
    self.admin || self .memberships.find_by(project_id: project.id) != nil && self.memberships.find_by(project_id: project.id).role == 'Owner'
  end

  def project_member_of(user)
   user.projects.map(&:users).flatten.include?(self)
 end
end
