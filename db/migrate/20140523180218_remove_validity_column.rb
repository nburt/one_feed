class RemoveValidityColumn < ActiveRecord::Migration
  def change
    remove_column :tokens, :is_valid
  end
end
