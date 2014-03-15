class Payment < ActiveRecord::Base
  belongs_to :loan
  belongs_to :sponsor
end
