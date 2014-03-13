class SponsorsController < ApplicationController
  def index
    render json: Loan.all
  end
end
