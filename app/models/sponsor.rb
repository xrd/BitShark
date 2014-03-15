# -*- coding: utf-8 -*-
class Sponsor < ActiveRecord::Base

  @@coinbase = Coinbase::Client.new(APP_CONFIG['coinbase']['api_key'], APP_CONFIG['coinbase']['api_secret'])

  validates :loan_id, presence: true
  validates :sponsor_social_id, presence: true
  validates :user_id, presence: true
  
  belongs_to :user
  belongs_to :loan
  
  def generate_callback_url
    "#{APP_CONFIG['root_url']}/payment/#{self.loan.code}"
  end

  
  
end
