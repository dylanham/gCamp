class User < ActiveRecord::Base
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true
  has_secure_password
  has_many :memberships
  has_many :comments
  def full_name
    "#{first_name} #{last_name}".titleize
  end
end
