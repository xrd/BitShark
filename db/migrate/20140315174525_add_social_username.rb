class AddSocialUsername < ActiveRecord::Migration
  def change
    add_column :sponsors, :social_email, :string
  end
end
