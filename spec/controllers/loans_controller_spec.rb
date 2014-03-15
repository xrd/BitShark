require 'spec_helper'

describe LoansController do

  before( :each ) do
    5.times do
      User.create email: Faker::Internet.email, nickname: Faker::Name.first_name, provider: "facebook", uid: (rand()*10000).to_i
    end
    2.times do
      Loan.create user_id: User.first, amount: rand()*500, loanee: Faker::Name.name, description: Faker::Lorem.paragraph
    end
    login_as User.first
  end

  describe "#create" do
    it "should properly parse amounts with $ signs in front" do
      post :create, loan: { amount: '$333', loanee: Faker::Name.name, description: Faker::Lorem.paragraph, user_id: User.first }
      expect( Loan.last.amount ).to eq 333.0
    end
  end
  
  describe "#index" do
    it "should get a list of users who are loaners" do
      get :all
      expect( JSON.parse( response.body ).length ).to eq( 2 )
    end
  end
  
end
