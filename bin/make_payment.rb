#!/usr/bin/env ruby

require 'curb'

code = ARGV.shift
payment = ARGV.shift

unless code and payment
  puts "Need code and payment"
  exit
end

id = (rand()*100000000).to_i

# params['order']['total_native']['cents']/100, params["order"]["transaction"]["id"] 

http = Curl.post("http://sharkbit.eqne.ws/payment/#{code}", {:order => { :total_native => { cents: payment }, transaction: { id: id } } } )
puts http.body_str


