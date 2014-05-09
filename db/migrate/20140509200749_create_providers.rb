class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :provider
      t.string :uid
      t.string :twitter_access_token
      t.string :twitter_access_token_secret
      t.integer :user_id
    end
  end
end