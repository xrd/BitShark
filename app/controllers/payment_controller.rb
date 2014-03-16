class PaymentController < ApplicationController
  def payment_received
    loan = Loan.find_by_code params[:code]
    json = JSON.parse( response.body )
    if loan
      loan.payment!( json['order']['total_native']['cents']/100, @current_user.id )
    end
  end
  
  def button
    @s = Sponsor.find_by_code( params[:code] )
  end
end
