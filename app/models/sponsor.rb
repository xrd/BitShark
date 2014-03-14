# -*- coding: utf-8 -*-
class Sponsor < ActiveRecord::Base

  @@coinbase = Coinbase::Client.new(APP_CONFIG['coinbase']['api_key'], APP_CONFIG['coinbase']['api_secret'])

  validates :loan_id, presence: true
  validates :sponsor_social_id, presence: true
  validates :user_id, presence: true
  
  belongs_to :user
  
  after_validation( on: :create ) do
    generate_secure_code()
    generate_button_code()
    self.status = "unpaid"
  end

  def generate_secure_code
    self.code = SecureRandom.hex(5)
  end

  def generate_callback_url
    "#{APP_CONFIG['root_url']}/payment/#{self.code}"
  end

  def register_payment!
    self.status = "paid"
  end
  
  def generate_button_code
    r = nil
    if @@coinbase
      name = "Loan Sponsorship for Loan: #{self.loan_id}"
      price =  10.00.to_money('USD')
      description = "Loan Sponsorship @ $10"
      custom_code = self.code
      cb_url = generate_callback_url()
      r = @@coinbase.create_button name, price, description, custom_code, { callback_url: cb_url }
    end
    self.button_code = ( r && r.button ) ? r.button.code : "xyz"
    # => "93865b9cae83706ae59220c013bc0afd"
    # r.embed_html
    # => "<div class=\"coinbase-button\" data-code=\"93865b9cae83706ae59220c013bc0afd\"></div><script src=\"https://coinbase.com/assets/button.js\" type=\"text/javascript\"></script>"
  end

  
end
