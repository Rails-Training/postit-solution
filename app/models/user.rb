class User < ActiveRecord::Base
  has_many :posts, foreign_key: :user_id
  has_many :comments, foreign_key: :user_id
  has_many :votes, foreign_key: :user_id
  
  has_secure_password validations: false
  
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}
  
  before_save :generate_slug
  
  def generate_slug
    the_slug = to_slug(self.username)
    user = User.find_by slug: the_slug
    counter = 1
    while user && user != self
      the_slug = append_suffix(the_slug, counter)
      user = User.find_by slug: the_slug
      counter += 1
    end
    self.slug = the_slug
  end
  
  def to_param
    self.slug
  end
  
  private
  
  def to_slug(name)
    str = name.strip.downcase
    str.gsub! /\s*[^a-z0-9]\s*/, '-'
    str.gsub /-+/, '-'
  end

  def append_suffix(str, counter)
    if str.split('-').last.to_i != 0
      the_slug = str.split('-').slice(0...-1).join('-') << '-' << counter.to_s
    else
      the_slug = str << '-' << counter.to_s
    end
  end
  
end