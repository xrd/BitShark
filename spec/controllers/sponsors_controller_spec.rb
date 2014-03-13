require 'spec_helper'

describe SponsorsController do

  before( :each ) do
    5.times do
      User.create email: Faker::Internet.email, nickname: Faker::Name.first_name, provider: "facebook", uid: (rand()*10000).to_i
    end
    2.times do
      Loan.create user_id: User.first, amount: rand()*500, name: Faker::Name.name, description: Faker::Lorem.paragraph
    end
  end
  
  describe "#index" do
    it "should get a list of users who are sponsors" do
      get :index
      JSON.parse( response.body ).length.should == 2
    end
  end
  
end
