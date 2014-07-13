class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.json :post_array
      t.integer :user_id
      t.index :user_id
      t.timestamps
    end
  end
end
