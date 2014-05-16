class AddIsValidToTokens < ActiveRecord::Migration
  def change
    add_column :tokens, :is_valid, :boolean
  end
end
