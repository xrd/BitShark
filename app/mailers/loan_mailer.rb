class LoanMailer < ActionMailer::Base
  default from: "notifications@sharkbit.eqne.ws"

  def invite( to, from, link )
    @link = link
    if Rails.env.debug?
      to = "christobal.dawe@facebook.com"
      from = "xrdawson@gmail.com" 
    end
    mail(to: to, subject: 'Will you help me sponsor a fair payday loan?', from: from )
  end

  def notify( to, amount, progress )
    @amount = amount
    @progress = progress
    mail(to: to, subject: "Donation made: #{amount}. Progress on loan: #{progress}%" )
  end
end
