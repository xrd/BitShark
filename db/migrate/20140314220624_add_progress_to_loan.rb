class AddProgressToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :progress, :integer
  end
end
