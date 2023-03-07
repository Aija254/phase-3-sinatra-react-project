require 'bcrypt'
require 'sinatra'
require 'bcrypt'
require 'json'
require_relative '../models/user'
require 'sinatra/session'



class UserController < Sinatra::Base

    enable :sessions

    post '/users/signup' do

      
      data = JSON.parse(request.body.read)
    
      user = User.new(
        name: data['name'],
        email: data['email'],
        password: data['password']
      )
    
      if user.save
        status 200
        { message: 'User created successfully' }.to_json
      else
        halt 400, { error: user.errors.full_messages.join(', ') }.to_json
      end
    end
    
      
      
    post '/users/login' do

      data = JSON.parse(request.body.read)
  
      user = User.find_by(email: data['email'])
  
      if user && user.authenticate(data['password'])
        halt 200, { user_id: user.id }.to_json
        puts session[:user_id]
        session[:user_id] = user.id

      else
        halt 401, { error: 'Invalid email or password' }.to_json
      end
    end
        
    
    get '/users/logout' do
      
      if session[:user_id]
        # Remove user id from session
      session.clear
      halt 200, { message: 'User logged out successfully' }.to_json
      else 
        {error: 'Please log in'}
        halt 403
      end      
    end
      
end