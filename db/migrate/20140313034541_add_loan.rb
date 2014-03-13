class AddLoan < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :user_id
      t.string :name
      t.string :description
      t.float :amount
      t.timestamps
    end
  end
end
