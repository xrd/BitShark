class AddButtonCodeToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :button_code, :text
  end
end
