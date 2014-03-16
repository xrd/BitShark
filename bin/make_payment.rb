#!/usr/bin/env ruby

code = ARGV.shift
payment = ARGV.shift

unless code and payment
  puts "Need code and payment"
  exit
end

id = random()*1000000

# params['order']['total_native']['cents']/100, params["order"]["transaction"]["id"] 

http = Curl.post("http://sharkbit.eqne.ws/payment", {:order => { :total_native => { cents: payment }, transaction: { id: id } } } )
puts http.body_str


