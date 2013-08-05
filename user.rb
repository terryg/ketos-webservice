require 'json'
require 'digest/md5'

require './provider'

class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String
  property :password, BCryptHash  
  property :token, String
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :providers

  def make_token(ip)
    self.token = Digest::MD5.hexdigest("#{self.id}-my-new-bcrypt-scheme-is-unstoppable-#{Time.now}-#{ip}")
    if !self.save
      puts "**** failed to save #{self.id}"
    end
  end

  def to_json(*a)
    providers = []
    self.providers.each do |p|
      providers << p.to_json
    end

    {
      :id => self.id,
      :email => self.email,
      :token => self.token,
      :since => self.created_at.to_s,
      :providers => providers
    }.to_json(*a)
  end
end
