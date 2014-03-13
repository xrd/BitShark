class SponsorsController < ApplicationController
  def index
    render json: Loan.all
  end

  def create
    loan = @current_user.loans.create loans_params
    render json: loan
  end

  def loans_params
    params.require(:loan).permit(:description,:name,:amount,:familiarity)
  end
end
