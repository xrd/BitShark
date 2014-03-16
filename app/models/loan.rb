class Loan < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  belongs_to :user
  has_many :payments
  validates :amount, numericality: { greater_than: 10 }

  def parse_amount
    if '$' == self.amount.to_s[0]
      self.amount = self.amount.to_s[1..-1].to_f
      puts "Amount: #{self.amount}"
    end
  end
  
  LIMIT = 75
  @@coinbase = Coinbase::Client.new(APP_CONFIG['coinbase']['api_key'], APP_CONFIG['coinbase']['api_secret'])
  
  def simple_description
    doc = Maruku.new(self.description)
    sanitized = strip_tags( doc.to_html )
    elipsed = sanitized.length > LIMIT ? ( sanitized[0..LIMIT] + "..." ) : sanitized
    "#{self.loanee}: #{elipsed}"
  end

  def invite_via_email( email, from, link )
    LoanMailer.invite( email, from, link )
  end
  
  def invite_on_facebook( username, email, link )
    LoanMailer.invite( "#{username}@facebook.com", email, link )
  end

  after_validation( on: :create ) do
    parse_amount()
    generate_secure_code()
  end

  def generate_secure_code
    self.code = SecureRandom.hex(5)
  end

  def generate_callback_url
    "#{APP_CONFIG['root_url']}/payment/#{self.code()}"
  end
  
  def donate_button
    html = nil
    begin
      if @@coinbase
        name = "Loan Sponsorship for Loan: #{self.id}"
        price =  10.00.to_money('USD')
        description = "Loan Sponsorship @ $10"
        cb_url = generate_callback_url()
        r = @@coinbase.create_button name, price, description, self.code, { callback_url: cb_url }
        html = r.embed_html
      end
    rescue Exception => e
      html = e.to_s
    end
    html
  end

  # recalculate progress with payment
  def payment!( payment, id )
    self.payments.create( amount: payment, transaction_id: id )
    total = 0
    self.payments.each do |p|
      total += p.amount
    end
    count = (100*(total/self.amount)).to_i
    update_attribute( :progress, [ count, 100 ].min )
    LoanMailer.notify( self.user.email, payment, self.progress )
  end
  
  def as_json( options={} )
    super( options.merge( methods: [ :simple_description, :donate_button ] ) )
  end
  
end
