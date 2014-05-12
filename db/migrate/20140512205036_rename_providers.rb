class RenameProviders < ActiveRecord::Migration
  def change
    rename_table :providers, :tokens
  end
end
