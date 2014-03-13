class LoansController < ApplicationController
  def all
    render json: Loan.all
  end

  def create
    loan = @current_user.loans.create loans_params
    render json: loan
  end

  def loans_params
    params.require(:loan).permit(:description,:loanee,:amount,:familiarity)
  end
end
