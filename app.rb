require 'sinatra'
require 'logger'

require './user'

class App < Sinatra::Base

  post '/register' do
    puts "**** register user with #{params[:email]}"
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
    puts "**** signin user with #{params[:email]}"
    user = User.first(:email => params[:email])
    if user.password == params[:password]
      user.make_token(request.ip)
      status 200
      body(user.to_json)
    else
      status 400
    end
  end

  post '/provider' do
    puts "**** authenticate token #{params[:token]}"
    user = User.first(:token => params[:token])
    puts "**** create for #{params[:provider]}"
    provider = Provider.first_or_create({ :user_id => user.id,
                                          :uid => params[:uid]},
                                        { :user_id => user.id,
                                          :uid => params[:uid],
                                          :name => params[:provider],
                                          :access_token => params[:token],
                                          :access_token_secret => params[:secret]
                                        })
    status 200
    body(provider.to_json)
  end

  post '/new' do
    puts "**** authenticate token #{params[:token]}"
    user = User.first(:token => params[:token])
    if user.nil?
      status 400
    else
      post = Post.create(:user_id => user.id, :text => params[:text])
      status 200
      body(post.to_json)
    end
  end
  
  private
  
end
