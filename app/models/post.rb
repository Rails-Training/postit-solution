class Post < ActiveRecord::Base 
  include VoteableLexSep
  
  belongs_to :creator, foreign_key: :user_id, class_name: :User
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: :true
  validates :url, presence: :true

  before_save :generate_slug
  
  def generate_slug
    the_slug = to_slug(self.title)
    post = Post.find_by slug: the_slug
    counter = 1
    while post && post != self
      the_slug = append_suffix(the_slug, counter)
      post = Post.find_by slug: the_slug
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