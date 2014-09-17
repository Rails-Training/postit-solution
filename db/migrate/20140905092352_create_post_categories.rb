class CreatePostCategories < ActiveRecord::Migration
  def change
    create_table :post_categories do |t|
      t.belongs_to :post
      t.belongs_to :category
    end
  end
end
