describe Sponsor do
  it "should start with a code" do
    expect( Sponsor.create.code ).to be_defined
  end
end
