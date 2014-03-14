require 'spec_helper'

params = {"friends"=>{"506507166"=>{"name"=>"Hans Anders Barklis", "id"=>"506507166", "selected"=>true}, "528913531"=>{"name"=>"Julian Bergquist", "id"=>"528913531", "selected"=>true}, "535935325"=>{"name"=>"Emily York", "id"=>"535935325", "selected"=>true}, "712816488"=>{"name"=>"Lev Anderson", "id"=>"712816488", "selected"=>true}, "742200627"=>{"name"=>"Emily Aldis", "id"=>"742200627", "selected"=>true}, "1595012804"=>{"name"=>"Emily Dana", "id"=>"1595012804", "selected"=>true}, "100000180844506"=>{"name"=>"David Berkham", "id"=>"100000180844506", "selected"=>true}}, "loan"=>2, "controller"=>"facebook", "action"=>"invite", "facebook"=>{"friends"=>{"506507166"=>{"name"=>"Hans Anders Barklis", "id"=>"506507166", "selected"=>true}, "528913531"=>{"name"=>"Julian Bergquist", "id"=>"528913531", "selected"=>true}, "535935325"=>{"name"=>"Emily York", "id"=>"535935325", "selected"=>true}, "712816488"=>{"name"=>"Lev Anderson", "id"=>"712816488", "selected"=>true}, "742200627"=>{"name"=>"Emily Aldis", "id"=>"742200627", "selected"=>true}, "1595012804"=>{"name"=>"Emily Dana", "id"=>"1595012804", "selected"=>true}, "100000180844506"=>{"name"=>"David Berkham", "id"=>"100000180844506", "selected"=>true}}, "loan"=>2}}

describe FacebookController do
  before( :each ) do
    @user = User.create email: Faker::Internet.email, nickname: Faker::Name.first_name, provider: "facebook", uid: (rand()*10000).to_i, auth_token: "abcdef"
    login_as( @user )
  end
  
  it "should invite a bunch of people" do
    friend_count = params['friends'].length
    expect {
      post :invite, params
    }.to change( Sponsor, :count ).by( friend_count )
    expect( @user.sponsors.count ).to eq friend_count
  end
end

