require 'sinatra'
require 'logger'
require 'json'

class App < Sinatra::Base
  enable :methodoverride

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
    request.body.rewind
    req = JSON.parse(request.body.read)
    puts "**** signin user with #{req['email']}"
    user = User.first(:email => req['email'])
    if user and user.password == req['password']
      user.make_token(request.ip)
      status 200
      body(user.to_json)
    else
      status 401
    end
  end

  post '/forgot_password' do
    request.body.rewind
    req = JSON.parse(request.body.read)
    puts "**** lost password for user with #{req['email']}"
    user = User.first(:email => req['email'])
    if user
    else
      status 401
    end
  end

  post '/provider/create/:provider' do
    puts "**** authenticate token #{params[:token]}"
    user = User.first(:token => params[:token])

    if user.nil?
      status 400
      puts "**** user is nil"
    else
      puts "**** create for #{user.id}"
      puts "**** provider #{params[:provider]}"
      puts "**** uid #{params[:uid]}"
      puts "**** access_token #{params[:access_token]}"
      puts "**** access_token_secret #{params[:access_token_secret]}"
      provider = Provider.first_or_create({ :user_id => user.id,
                                            :uid => params[:uid]
                                          },
                                          { :user_id => user.id,
                                            :uid => params[:uid],
                                            :name => params[:provider],
                                            :access_token => params[:access_token],
                                            :access_token_secret => params[:access_token_secret]
                                          })
      puts "**** created provider id [#{provider.id}]"
      provider.errors.each do |e|
        puts "**** #{e}"
      end
      status 200
      body(provider.to_json)
    end
  end

  delete '/provider/delete/:provider' do
    puts "*** #{request.env}"
    puts "*** request[\"Authorization\"] #{headers["Authorization"]}"

    headers = request.env['HTTP_HEADERS']
    puts "*** headers #{headers}"
    sliced = headers.slice(1, headers.length-2)
    puts "*** sliced #{sliced}"
    h = {}
    sliced.split(',').each do |substr|
      ary = substr.strip.split('=>')
      h[ary.first.tr('"','')] = ary.last.tr('"','')
    end

    auth = h['Authorization']
    puts "*** auth #{auth}"
    token = auth.gsub('Token ', '')
    puts "**** authenticate token #{token}"
    user = User.first(:token => token)

    if user.nil?
      status 400
      puts "**** user is nil"
    else
      provider = Provider.first({ :user_id => user.id, :name => params[:provider]})
      if provider.nil? then
        status 404
      else
        if provider.destroy then
          status 200
        else
          status 500
        end
      end
    end
  end

  post '/item' do
    puts "**** authenticate token #{params[:token]}"
    user = User.first(:token => params[:token])
    if user.nil?
      status 400
    else
      puts "@[production.item] #{{'uid'=>user.id, 'source'=>params[:source], 'created_at'=>params[:created_at], 'text'=>params[:text]}.to_json}"
      status 200
    end
  end
  
  private
  
end
