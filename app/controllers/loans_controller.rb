class LoansController < ApplicationController
  def all
    render json: Loan.all
  end

  def create
    # massage the amount
    amount = params[:loan][:amount]
    params[:loan][:amount] = amount[1..-1] if "$" == amount.to_s[0]
    loan = @current_user.loans.create loans_params
    render json: loan
  end

  def loans_params
    params.require(:loan).permit(:description,:name,:loanee,:amount,:familiarity)
  end
end
