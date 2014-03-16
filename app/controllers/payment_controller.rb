class PaymentController < ApplicationController
  
  skip_before_filter :verify_authenticity_token

  def payment_received
    loan = Loan.find_by_code params[:code]
    if loan
      cents = params[:order][:total_native][:cents].to_i
      loan.payment!( cents/100, params[:order][:transaction][:id] )
    end
    render json: loan.reload
  end
  
  def button
    @s = Sponsor.find_by_code( params[:code] )
  end
end
