# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/' do
    return erb(:index)
  end 

  # get '/about' do 
  #   return erb(:about)
  # end 


  get '/albums' do 
    repo = AlbumRepository.new
    @albums = repo.all 

    return erb(:albums_list)
  end 

  get '/albums/new' do
  
    return erb(:new_album)
  end

  post '/albums' do 
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)
    @album_title = params[:title]
    return erb(:album_created)
  end

  get '/albums/:id' do 
    repo = AlbumRepository.new
    artist_repo = ArtistRepository.new

    
    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)
    return erb(:album)
  end 

  get '/artists' do 
    repo = ArtistRepository.new 

    @artists = repo.all

    return erb(:artists_list)
  end 

  get '/artists/new' do 
    return erb(:new_artist)
  end

  post '/artists' do 
    repo = ArtistRepository.new 

    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)

    @artist_name = params[:name]
    return erb(:artist_created)
  end 

  get '/artist/:id' do 
    repo = ArtistRepository.new

    @artist = repo.find(params[:id])

    return erb(:artist)
  end

end