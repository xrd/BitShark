class AddLoan < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :user_id
      t.string :loanee
      t.string :description
      t.string :familiarity
      t.float :amount
      t.timestamps
    end
  end
end
