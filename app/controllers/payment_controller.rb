class PaymentController < ApplicationController
  def payment_received
    code = params[:code][4..-1]
    loan = Sponsor
  end
  
  def button
    @s = Sponsor.find_by_code( params[:code] )
  end
end
