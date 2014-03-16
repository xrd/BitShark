class MakeFullText < ActiveRecord::Migration
  def change
    change_column :users, :full,  :text
  end
end
