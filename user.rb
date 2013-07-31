require 'json'

class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String
  property :password, BCryptHash  
  property :created_at, DateTime
  property :updated_at, DateTime

  def to_json(*a)
    {
      :id => self.id,
      :email => self.email,
      :since => self.created_at.to_s
    }.to_json(*a)
  end
end
