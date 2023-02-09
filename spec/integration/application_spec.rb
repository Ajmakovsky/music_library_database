require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  # hello 
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do 
    album_seed_sql = File.read('spec/seeds/albums_seeds.sql')
    artist_seed_sql = File.read('spec/seeds/artists_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(artist_seed_sql)
    connection.exec(album_seed_sql)
  end


  context 'GET /albums/:id' do 
    it 'returns the HTML content for album 1' do 
      response = get('/albums/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>') 
      expect(response.body).to include('Release year: 1989') 
      expect(response.body).to include('Artist: Pixies') 
    end 
  end 

  
  # context 'GET /' do 
  #   it 'returns a hello page if the password is correct' do
  #     response = get('/', password: 'abcd')

  #     expect(response.body).to include('Hello!')
  #   end

  #   it 'returns a forbidden if password is incorrect' do
  #     response = get('/', password: 'aigbiueb')

  #     expect(response.body).to include('Access Forbidden!')
  #   end
  # end 

  # context "GET /albums" do
  #   it 'should return list of albums' do 
  #   response = get('/albums')

  #   expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

  #   expect(response.status).to eq(200)
  #   expect(response.body).to eq expected_response
  #   end
  # end

  context "GET /albums" do 
    it 'should return an html page list of all albums' do 
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include 'Title: Doolittle'
      expect(response.body).to include 'Release year: 1989'
      expect(response.body).to include 'Title: Folklore'
      expect(response.body).to include 'Release year: 2020'
    end 

    it 'should return an html page list of albums with links to their albums' do

    response = get('/albums')
    expect(response.status).to eq 200 
    expect(response.body).to include('<a href="/albums/1">Title: Doolittle</a>')
    expect(response.body).to include('<a href="/albums/3">Title: Waterloo</a>')
    end
  end 

  context "GET /albums/new" do 
    it 'returns an HTML post form to create a new artist' do 
      response = get('/albums/new')

      expect(response.status).to eq 200 
      expect(response.body).to include('<form method="POST" action="/albums">')
      expect(response.body).to include('<input type="text" name="title">')
      expect(response.body).to include('<input type="text" name="release_year">')
      expect(response.body).to include('<input type="text" name="artist_id">')
    end 
  end 

  context "POST /albums" do 
    it "should create a new album" do 
      response = post('/albums',
         title: "Thank u next", 
         release_year: "2019", 
         artist_id: "1")

      expect(response.status).to eq 200 
      expect(response.body).to include '<h1>New Album "Thank u next" added!</h1>'

      response = get('/albums')
      expect(response.body).to include("Thank u next")

    end

    it 'should create another new album' do 
      response = post('/albums', 
      title: "Voyage",
      release_year: "2022", 
      artist_id: "2")

      expect(response.status).to eq 200

      response = get('/albums')
      expect(response.status).to eq 200 
      expect(response.body).to include "Voyage"
    end
  end

  context "GET /artists" do 
    # it 'gets a list of all artists' do 
    #   response = get('/artists')

    #   expected_response = "Pixies, ABBA, Taylor Swift, Nina Simone"

    #   expect(response.status).to eq 200 
    #   expect(response.body).to eq expected_response
    # end 

    it 'gets a list of all artists' do 
      response = get('/artists')

      expect(response.status).to eq 200 
      expect(response.body).to include('<a href="/artist/1">Name: Pixies</a>')
      expect(response.body).to include('<a href="/artist/3">Name: Taylor Swift</a>')
      expect(response.body).to include('Genre: Rock')
    end 
  end 

  context "GET /artists/new" do 
    it 'returns an HTML post form to create a new artist' do 
      response = get('artists/new')

      expect(response.status).to eq 200 
      expect(response.body).to include '<form method="POST" action="/artists">'
      expect(response.body).to include '<input type="text" name="name">'
      expect(response.body).to include '<input type="text" name="genre">'

    end 
  end 

  context "POST /artists" do 
    it "creates a new artist" do 
      response = post('/artists',
      name: "Ariana Grande", 
      genre: "Pop")

      expect(response.status).to eq 200 
      expect(response.body).to include '<h1>New artist "Ariana Grande" created!</h1>'
    end 
  end 

  context "GET /artist" do 
    it 'returns HTML for artist 1' do
      response = get('/artist/1')

      expect(response.status).to eq 200 
      expect(response.body).to include "Name: Pixies"
      expect(response.body).to include "Genre: Rock"
    end
  end 
end

