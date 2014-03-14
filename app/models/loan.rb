class Loan < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  belongs_to :user
  has_many :sponsors

  LIMIT = 50
  
  def simple_description
    doc = Maruku.new(self.description)
    sanitized = strip_tags( doc.to_html )
    elipsed = sanitized.length > LIMIT ? ( sanitized[0..LIMIT] + "..." ) : sanitized
    "#{self.loanee}: #{elipsed}"
  end
  
  def as_json( options={} )
    super( options.merge( methods: :simple_description ) )
  end
  
end
