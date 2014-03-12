class AddUser < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :nickname
      t.string :email
      t.string :full
      t.string :auth_token
      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
