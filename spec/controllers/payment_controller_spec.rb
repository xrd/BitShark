require 'spec_helper'

json = '{
  "order": {
    "id": "5RTQNACF",
    "created_at": "2012-12-09T21:23:41-08:00",
    "status": "completed",
    "total_btc": {
      "cents": 100000000,
      "currency_iso": "BTC"
    },
    "total_native": {
      "cents": 1253,
      "currency_iso": "USD"
    },
    "custom": "order1234",
    "receive_address": "1NhwPYPgoPwr5hynRAsto5ZgEcw1LzM3My",
    "button": {
      "type": "buy_now",
      "name": "Alpaca Socks",
      "description": "The ultimate in lightweight footwear",
      "id": "5d37a3b61914d6d0ad15b5135d80c19f"
    },
    "transaction": {
      "id": "514f18b7a5ea3d630a00000f",
      "hash": "4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b",
      "confirmations": 0
    },
    "customer": {
      "email": "coinbase@example.com",
      "shipping_address": [
        "John Smith",
        "123 Main St.",
        "Springfield, OR 97477",
        "United States"
      ]
    }
  }
}'

describe PaymentController do
  before( :each ) do
    @l = Loan.create user_id: User.first, amount: rand()*500, loanee: Faker::Name.name, description: Faker::Lorem.paragraph
  end
  
  it "should retrieve the correct loan" do
    post "/payment/#{@l.code}", JSON.parse( json ) #, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect( @l.reload.progress ).to ne 0
  end
end
