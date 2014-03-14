# -*- coding: utf-8 -*-
class Sponsor < ActiveRecord::Base

  @@coinbase = Coinbase::Client.new(ENV['COINBASE_API_KEY'], ENV['COINBASE_API_SECRET'])
  
  belongs_to :user
  
  after_validation( on: :create ) do
    generate_secure_code()
    generate_button_code()
  end

  def generate_secure_code
    self.code = SecureRandom.hex(5)
  end

  def generate_button_code
    r = @@coinbase.create_button "Your Order #1234", 42.95.to_money('EUR'), "1 widget at €42.95", "my custom tracking code for this order"
    self.button_code = r.button.code
    # => "93865b9cae83706ae59220c013bc0afd"
    # r.embed_html
    # => "<div class=\"coinbase-button\" data-code=\"93865b9cae83706ae59220c013bc0afd\"></div><script src=\"https://coinbase.com/assets/button.js\" type=\"text/javascript\"></script>"
  end

  
end
