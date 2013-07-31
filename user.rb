require 'json'

class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String
  property :password, BCryptHash  
  property :token, BCryptHash
  property :created_at, DateTime
  property :updated_at, DateTime

  def make_token(ip)
    self.token = "#{self.id}-my-new-bcrypt-scheme-is-unstoppable-#{Time.now}-#{ip}"
    self.save
  end

  def to_json(*a)
    {
      :id => self.id,
      :email => self.email,
      :token => self.token,
      :since => self.created_at.to_s
    }.to_json(*a)
  end
end
