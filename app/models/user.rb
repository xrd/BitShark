class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  has_many :loans
  has_many :sponsors
  validates_presence_of :email, :nickname, :provider, :uid
  validates_uniqueness_of :email

  before_validation( :on => :create ) do
    self.provider.downcase!
  end

  def administrator?
    "administrator".eql? self.role
  end

  def as_json( options={} )
    { nickname: self.nickname }
  end

  def self.create_with_omniauth(auth)
    u = create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['name']
      user.nickname = auth['info']['nickname'] || auth['info']['name']
      user.email = auth['info']['email']
      user.full = auth.to_yaml
      user.auth_token = auth['credentials']['token']
    end
    u
  end
end
