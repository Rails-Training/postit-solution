class Post < ActiveRecord::Base 
  include VoteableLexSep, SluggableLexSep
  
  belongs_to :creator, foreign_key: :user_id, class_name: :User
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: :true
  validates :url, presence: :true
  
  sluggable_column :title

end