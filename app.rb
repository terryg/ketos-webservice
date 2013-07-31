require 'sinatra'
require 'omniauth'
require 'omniauth-twitter'

require './user'

class App < Sinatra::Base
  enable :sessions

  before do
    content_type 'application/json'
  end

  post '/register' do
    puts "**** register user with #{params[:email]}"
    user = User.first_or_create({:email => params[:email]},
                                {:email => params[:email],
                                  :password => params[:password],
                                  :created_at => Time.now,
                                  :updated_at => Time.now})
    session[:user_id] = user.id
    status 200
    body(user.to_json)
  end

  post '/signin' do
    puts "**** signin user with #{params[:email]}"
    user = User.first(:email => params[:email])
    if user.password == params[:password]
      session[:user_id] = user.id
      status 200
      body(user.to_json)
    else
      status 400
    end
  end

  get '/auth/:provider/callback' do
    
  end
  
  get '/auth/failure' do
    redirect '/'
  end

  get '/signout' do
    session[:user_id] = nil
    status 200
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def current_user
    @current_user ||= User.get(session[:user_id]) if session[:user_id]
  end

end
