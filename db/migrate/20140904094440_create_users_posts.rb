class CreateUsersPosts < ActiveRecord::Migration
  def change
      add_column :posts, :user_id, :INTEGER
  end
end
