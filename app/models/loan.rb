class Loan < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  belongs_to :user
  has_many :sponsors

  LIMIT = 50
  @@coinbase = Coinbase::Client.new(APP_CONFIG['coinbase']['api_key'], APP_CONFIG['coinbase']['api_secret'])
  
  def simple_description
    doc = Maruku.new(self.description)
    sanitized = strip_tags( doc.to_html )
    elipsed = sanitized.length > LIMIT ? ( sanitized[0..LIMIT] + "..." ) : sanitized
    "#{self.loanee}: #{elipsed}"
  end

  def loan_code
    "Loan#{self.id}"
  end
  
  def generate_callback_url
    "#{APP_CONFIG['root_url']}/payment/#{loan_code()}"
  end
  
  def donate_button
    if @@coinbase
      name = "Loan Sponsorship for Loan: #{self.id}"
      price =  10.00.to_money('USD')
      description = "Loan Sponsorship @ $10"
      custom_code = loan_code()
      cb_url = generate_callback_url()
      r = @@coinbase.create_button name, price, description, custom_code, { callback_url: cb_url }
    end
    r.embed_html
  end
  
  def as_json( options={} )
    super( options.merge( methods: [ :simple_description, :donate_button ] ) )
  end
  
end
