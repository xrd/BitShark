class PaymentController < ApplicationController
  
  skip_before_filter :verify_authenticity_token

  def payment_received
    loan = Loan.find_by_code params[:code]
    if loan
      loan.payment!( params['order']['total_native']['cents']/100, params["order"]["transaction"]["id"] )
    end
    render json: loan
  end
  
  def button
    @s = Sponsor.find_by_code( params[:code] )
  end
end
