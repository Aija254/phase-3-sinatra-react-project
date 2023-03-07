require 'sinatra/session'

class MovieController < Sinatra::Base

    enable :sessions
    set :default_content_type, 'application/json'

    # A get request method
       get '/movies' do
           movie = Movie.all
           movie.to_json
       end

       
    post '/movies/create/:user_id' do
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

end