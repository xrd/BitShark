require 'spec_helper'

describe Loan do

  before( :each ) do
    User.create email: Faker::Internet.email, nickname: Faker::Name.first_name, provider: "facebook", uid: (rand()*10000).to_i
    @l = Loan.create user_id: User.first, amount: 100, name: Faker::Name.name, description: Faker::Lorem.paragraph
  end

  describe "#payments" do
    it "should have payments" do
      @l.payment!( 10, 1 )
      @l.payment!( 10, 1 )
      expect( @l.reload.payments.length ).to eq 2
    end
  end
  
  describe "#progress" do
    it "should recalculate progress when payment is made" do
      @l.payment!( 10, 1 )
      expect( @l.progress ).to eq 90
    end
    
    it "should never go above 100" do
      @l.payment!( 1000, 1 )
      expect( @l.progress ).to eq 100
    end
  end
end
