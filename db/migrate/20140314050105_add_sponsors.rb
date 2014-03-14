class AddSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :button_code
      t.string :sponsor_social_id
      t.string :code
      t.integer :user_id
      t.integer :loan_id
      t.string :status
      t.timestamps
    end
  end
end
