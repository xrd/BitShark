
require 'spec_helper'

describe PaymentController do
  before( :each ) do
    @l = Loan.create user_id: User.first, amount: rand()*500, name: Faker::Name.name, description: Faker::Lorem.paragraph
  end
  
  it "should retrieve the correct loan" do
    
  end
end
