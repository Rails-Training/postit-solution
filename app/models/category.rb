class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories
  validates :name, presence: :true
  
  before_save :generate_slug
  
  def generate_slug
    the_slug = to_slug(self.name)
    category = Category.find_by slug: the_slug
    counter = 1
    while category && category != self
      the_slug = append_suffix(the_slug, counter)
      category = Category.find_by slug: the_slug
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