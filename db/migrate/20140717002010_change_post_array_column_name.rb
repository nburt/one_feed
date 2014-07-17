class ChangePostArrayColumnName < ActiveRecord::Migration
  def change
    rename_column :posts, :post_array, :post_hash
  end
end
