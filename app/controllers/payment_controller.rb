class PaymentController < ApplicationController
  def received
    sponsor = Sponsor.find_by_code( params[:order][:custom] )
    sponsor.register_payment!
    render json: { status: 'ok' }
  end

  def button
    @s = Sponsor.find_by_code( params[:code] )
  end
end
