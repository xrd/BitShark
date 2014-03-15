class PaymentController < ApplicationController
  def sponsor_received
    sponsor = Sponsor.find_by_code( params[:order][:custom] )
    sponsor.register_payment!
    render json: { status: 'ok' }
  end

  def loan_received
    code = params[:code][4..-1]
    loan = Sponsor
  end
  
  def button
    @s = Sponsor.find_by_code( params[:code] )
  end
end
