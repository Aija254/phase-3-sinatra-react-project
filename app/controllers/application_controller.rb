class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # Add your routes here
  post '/movies/create' do
    request.body.rewind
    data = JSON.parse(request.body.read)
  
    movie = Movie.new(
      title: data['title'],
      year: data['description'],
      user_id: data['user_id']
    )
  
    if movie.save
      status 201
      movie.to_json
    else
      status 403
      { errors: movie.errors }.to_json
    end
  end
  
  get '/movies/:user_id' do
    movie = Movie.where(user_id: params[:user_id])

    if movie
      movie.to_json
    else
      status 403
    end
  end
  
  put '/movies/update/:user_id' do
    
    movie = Movie.find(params[:user_id])
    title = params[:title]
    description = params[:description]
    
    if movie.update(title: title, description: description)
    else
      status 400
      json movie.errors
    end
  end

  delete '/movies/delete/:id' do
    movie = Movie.find_by(id: params[:id])
    
    if movie
      movie.destroy
      status 204
    else
      status 404
      { error: "Movie not found" }.to_json
    end
  end
    
  post '/users/create' do
    request.body.rewind
    data = JSON.parse(request.body.read)
  
    user = User.new(
      name: data['name'],
      email: data['email'],
      password: data['password']
    )
  
    if user.save
      status 200
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
