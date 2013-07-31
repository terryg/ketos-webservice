require 'json'

class Post
  include DataMapper::Resource

  belongs_to :user

  property :id, Serial
  property :text, String

  def to_json(*a)
    {
      :id => self.id,
      :user_id => self.user_id,
      :text => self.text
    }.to_json(*a)
  end
end
