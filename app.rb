require 'sinatra'
require 'logger'

require './user'

class App < Sinatra::Base
  enable :logging

  before do
    logger.level = Logger::DEBUG
    content_type 'application/json'
  end

  post '/register' do
    logger.debug "**** register user with #{params[:email]}"
    user = User.first_or_create({:email => params[:email]},
                                {:email => params[:email],
                                  :password => params[:password],
                                  :created_at => Time.now,
                                  :updated_at => Time.now})
    user.make_token(request.ip)
    status 200
    body(user.to_json)
  end

  post '/signin' do
    logger.debug "**** signin user with #{params[:email]}"
    user = User.first(:email => params[:email])
    if user.password == params[:password]
      user.make_token(request.ip)
      status 200
      body(user.to_json)
    else
      status 400
    end
  end

  post '/new' do
    logger.debug "**** authenticate token #{params[:token]}"
    user = User.first(:token => params[:token])
#    if user.nil?
#      status 400
#    else
      post = Post.create(:user_id => user.id, :text => params[:text])
      status 200
      body(post.to_json)
#    end
  end
  
  private
  
  def authenticate


  end

end
