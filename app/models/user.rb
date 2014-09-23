class User < ActiveRecord::Base
  include Sluggable
  
  has_many :posts, foreign_key: :user_id
  has_many :comments, foreign_key: :user_id
  has_many :votes, foreign_key: :user_id
  
  has_secure_password validations: false
  
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}
  
  sluggable_column :username
      
  def admin?
    self.role != nil && self.role.downcase == 'admin'
  end
  
  def moderator?
    self.role != nil && self.role.downcase == 'moderator'
  end
  
end