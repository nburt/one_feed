class AddIndexForAuthorizations < ActiveRecord::Migration
  def change
    add_index :authorizations, :user_id
  end
end
