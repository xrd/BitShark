class User < ActiveRecord::Base

  has_many :ssh_keys
  has_many :repositories

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

  def import_keys
    # Use the oauth, get the keys
    client = Octokit::Client.new(:login => self.nickname, :oauth_token => self.auth_token )
    
    keys = client.keys
    keys.each do |k|
      key = SshKey.from_octokit_key( k )
      logger.info "Importing key: #{key.inspect}"
      self.ssh_keys << key
    end
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
