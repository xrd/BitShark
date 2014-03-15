class AddCodeToLoanAndRemoveSponsors < ActiveRecord::Migration
  def change
    drop_table :sponsors
    add_column :loans, :code, :string
  end
end
