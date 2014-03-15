class AddPayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :loan_id
      t.integer :sponsor_id
      t.float :amount
      t.timestamps
    end
  end
end
