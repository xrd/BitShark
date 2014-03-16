#!/usr/bin/env ruby

require 'curb'
require 'json'

code = ARGV.shift
payment = ARGV.shift

unless code and payment
  puts "Need code and payment"
  exit
end

id = (rand()*100000000).to_i

# params['order']['total_native']['cents']/100, params["order"]["transaction"]["id"] 
json = ( {order: { total_native: { cents: payment }, transaction: { id: id } } } ).to_json

http = Curl.post("http://sharkbit.eqne.ws/payment/#{code}", json ) do |curl|
  curl.headers['Accept'] = 'application/json'
  curl.headers['Content-Type'] = 'application/json'
  curl.headers['Api-Version'] = '2.2'
end
puts http.body_str


