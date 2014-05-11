class RenameColumnsFromProviders < ActiveRecord::Migration
  def change
    change_table :providers do |t|
      t.rename :twitter_access_token, :access_token
      t.rename :twitter_access_token_secret, :access_token_secret
    end
  end
end
