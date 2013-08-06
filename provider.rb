require 'json'

class Provider
  include DataMapper::Resource

  belongs_to :user

  property :id, Serial
  property :uid, String
  property :name, String
  property :access_token, String, :length => 256
  property :access_token_secret, String
  property :created_at, DateTime
  property :updated_at, DateTime

  def to_json(*a)
    {
      :id => self.id,
      :uid => self.uid,
      :provider => self.name,
      :access_token => self.access_token,
      :access_token_secret => self.access_token_secret
    }.to_json(*a)
  end
end
