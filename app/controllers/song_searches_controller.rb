require 'rubygems'
require 'open-uri'
require 'json'
require 'rdio_api'


SONG_SEARCH_URL = "http://developer.echonest.com/api/v4/song/search?api_key=C3KAM8MI2NSR1PCX7&format=json&results=10&bucket=id:spotify-WW&bucket=audio_summary&bucket=song_type&sort=song_hotttnesss-desc&bucket=tracks&title="
SONG_SEARCH_URL_limit = "http://developer.echonest.com/api/v4/song/search?api_key=C3KAM8MI2NSR1PCX7&format=json&results=1&bucket=id:spotify-WW&bucket=audio_summary&bucket=song_type&sort=song_hotttnesss-desc&bucket=tracks&title="
URL = "http://developer.echonest.com/api/v4/song/search?api_key=DMXIXHBUKTIQUHV9F&format=json&results=5&bucket=id&bucket=audio_summary&bucket=tracks&title="
ARTIST_URL = "http://developer.echonest.com/api/v4/artist/images?api_key=DMXIXHBUKTIQUHV9F&format=json&results=1&start=0&license=unknown&name="
ARTIST_SONGS_URL = "http://developer.echonest.com/api/v4/artist/songs?api_key=C3KAM8MI2NSR1PCX7&format=json&start=0&results=25&name="
ARTIST_BLOG_URL = "http://developer.echonest.com/api/v4/artist/blogs?api_key=DMXIXHBUKTIQUHV9F&format=json&results=3&start=0&name="
ARTIST_BIO_URL = "http://developer.echonest.com/api/v4/artist/biographies?api_key=DMXIXHBUKTIQUHV9F&format=json&results=1&start=0&license=cc-by-sa&name="
SONG_SEARCH_URL_ARTIST = "http://developer.echonest.com/api/v4/song/search?api_key=C3KAM8MI2NSR1PCX7&format=json&results=1&bucket=id:spotify-WW&bucket=audio_summary&bucket=song_type&bucket=tracks&title="
ALBUM_IMG_URL = "http://developer.echonest.com/api/v4/song/search?api_key=DMXIXHBUKTIQUHV9F&format=json&results=25&bucket=id:7digital-US&bucket=audio_summary&bucket=song_type&bucket=tracks&title="
PLAYLIST_URL = "http://developer.echonest.com/api/v4/playlist/static?api_key=C3KAM8MI2NSR1PCX7&format=json&results=100&type=artist-radio&bucket=tracks&bucket=id:spotify-WW&artist="
PLAYLIST_GENRE_URL = "http://developer.echonest.com/api/v4/playlist/static?api_key=C3KAM8MI2NSR1PCX7&format=json&results=30&type=genre-radio&bucket=tracks&bucket=id:spotify-WW&genre="

$type = ""


class SongSearchesController < ApplicationController
  # before_action :set_song_search, only: [:show, :edit, :update, :destroy]

  # # GET /song_searches
  # # GET /song_searches.json
  # def index
  #   @song_searches = SongSearch.all
  # end

  # GET /song_searches/1
  # GET /song_searches/1.json
  def show()
    / @song_search = SongSearch.new()
	 @song_search.get_song_search_details(params[:name])/
	url = SONG_SEARCH_URL + URI::encode(params[:name])
    result = JSON.parse(open(url).read)
    if is_success?(result) then
    	# check if a track is found
    	#valid song with track
    	song_elem = result["response"]["songs"]
		#@img_result = JSON.parse(open(ARTIST_URL + song_elem["artist_id"]).read)
		#@artist_songs = JSON.parse(open(ARTIST_SONGS_URL + song_elem["artist_id"]).read)
		#@artist_img = @img_result["response"]["images"][0]["url"]
		
		@spotify_id = []
		@title = []
		@artist_name = []
		@song_type = []
		@artist_img = []
		@song_idx = 0
		while(@song_idx < result["response"]["songs"].length )
			
			if has_tracks?(result,@song_idx) then
				
				check = false
				@name_artist = song_elem[@song_idx]["artist_name"]
				for item in @artist_name
					if(@name_artist == item)
						check = true
					end
				end
				
				unless check == true
					unless (!(song_elem[@song_idx].has_key? ["artist_foreign_ids"]))
						begin
							@img_result = JSON.parse(open(ARTIST_URL + URI::encode(@name_artist)).read)
							@artist_img << @img_result["response"]["images"][0]["url"]
							
						rescue
							@artist_img << "http://www.sellingpage.com/images/no_photo_icon.PNG"
						end
						@title << song_elem[@song_idx]["title"]
						@artist_name << song_elem[@song_idx]["artist_name"]
						@song_type << song_elem[@song_idx]["song_type"]
						@spotify_id << extract_id(song_elem[@song_idx]["artist_foreign_ids"][0]["foreign_id"])
					end
				end
				
			end
			
			unless has_tracks?(result,@song_idx)  
				@name_img = song_elem[@song_idx]["artist_name"]
				
						
				/for song in song_elem[@song_idx]["tracks"] do/
					
					for item in @artist_name
						if(@name_img == item)
							check = true
						end
					end
					unless check == true
						#unless (!(song_elem[@song_idx].has_key? ["artist_foreign_ids"]))
						begin
							@img_result = JSON.parse(open(ARTIST_URL + URI::encode(@name_img)).read)
							@artist_img << @img_result["response"]["images"][0]["url"]
							
						rescue
							@artist_img << "http://www.sellingpage.com/images/no_photo_icon.PNG"
						end	
							@title << song_elem[@song_idx]["title"]
							@artist_name << song_elem[@song_idx]["artist_name"]
							@song_type << song_elem[@song_idx]["song_type"]
							@spotify_id << extract_id(song_elem[@song_idx]["tracks"][0]["foreign_id"])
						#end
					end
					
					
				/end/
			end
			@song_idx += 1
			
		end
    	@spotify_id = @spotify_id.zip(@title, @artist_name, @song_type, @artist_img);

		
   	end
	
  end
  
  def artist
  begin
	if params[:param] == nil
		artist_name = params[:name]
	elsif params[:name] == nil
		artist_name = params[:param]
	end
	
	 @artist_songs_result = JSON.parse(open(ARTIST_SONGS_URL + URI::encode(artist_name)).read)
	 @artist_bio_result = JSON.parse(open(ARTIST_BIO_URL + URI::encode(artist_name)).read)
	 @artist_songs = []
	 @sng = []
	 @artist_bio = @artist_bio_result["response"]["biographies"][0]["text"]
	 
		for song in @artist_songs_result["response"]["songs"]
			unless @artist_songs.include?(song["title"])
				@artist_songs << song["title"]
			end
		end
		
		#puts @artist_songs
		#puts artist_name
		songs_artist(artist_name, @artist_songs)
		rescue
		
		end
  end
  
  def songs_artist(artist_name, song_name)
	i = 0
	@spotify_id = []
			@title = []
			@artist_name = []
			@song_type = []
			@artist_img = []
			begin
				@img_result = JSON.parse(open(ARTIST_URL + URI::encode(artist_name)).read)
				@artist_img << @img_result["response"]["images"][0]["url"]
				
			rescue
				@artist_img << "http://www.sellingpage.com/images/no_photo_icon.PNG"
			end
	for name in song_name
		url = SONG_SEARCH_URL_limit + URI::encode(name) + "&artist=" + URI::encode(artist_name)
		
		begin
			result = JSON.parse(open(url).read)
			puts i
			puts result
		rescue
			next
		end
		if is_success?(result) then
			# check if a track is found
			#valid song with track
			song_elem = result["response"]["songs"][0]
			
			
			@song_idx = 0
			/while(@song_idx < result["response"]["songs"].length )/
				
				if has_tracks?(result,0) then
					check = true
					@name_artist = song_elem["artist_name"]
					
					#puts @img_result
					
					unless @title.include? song_elem["title"]
							check = false
						end
					
					
					unless check == true
						unless (!(song_elem.has_key? ["artist_foreign_ids"]))
							@title << song_elem["title"]
							@artist_name << song_elem["artist_name"]
							@song_type << song_elem["song_type"]
							@spotify_id << extract_id(song_elem["artist_foreign_ids"][0]["foreign_id"])
						end
					end
					
				end
				
				unless has_tracks?(result,0)  
					@name_img = song_elem["artist_name"]
					check = true
					
					#for song in song_elem[@song_idx]["tracks"] do
						
						
						unless @title.include? song_elem["title"]
							check = false
						end
						
						unless check == true
						#unless (!(song_elem[@song_idx].has_key? ["artist_foreign_ids"]))
							@title << song_elem["title"]
							@artist_name << song_elem["artist_name"]
							@song_type << song_elem["song_type"]
							@spotify_id << extract_id(song_elem["tracks"][0]["foreign_id"])
						#end
						end
						
						
					#end
				end
				i += 1
				
			/end/
			
			
		end
	end
	@spotify_id = @spotify_id.zip(@title, @artist_name, @song_type, @artist_img)

  end
  

def album
begin
# Methods that act on behalf of a user require an access token, OmniAuth is best for this

# Initialize a new Rdio client
client = RdioApi.new(:consumer_key => 'a8t88rurd38fk64xeawp7yyu', :consumer_secret => 'hFKpGkvUqG')

result =  client.search(:query => params[:name], :types => "album")
@img = result["results"][0]["icon"]
@key =  result["results"][0]["key"]
rescue
end

end
  
  def playlist_songs
		@song_search = SongSearch.new()
		begin
			unless params[:name].empty?
			if $type == "artist"
				@song_search.playlist(params[:name])
			elsif $type == "genre"
				@song_search.genre_playlist(params[:name])
			end
			end
		rescue
			
		end
	end
	
  def test_type
	@song_search = SongSearch.new()
	if params[:name] == "artist"
		$type = "artist"
	elsif params[:name] == "genre"
		$type = "genre"
	end
	render "playlist_songs"
  end

  #Prinal start
  def genre
    @song_search = SongSearch.new()
    @song_search.genre_playlist(params[:name])
    render "playlist_songs"
  end
  #Prinal end
  
  def is_success?(result)
  	result["response"]["status"]["message"] == "Success" && !result["response"]["songs"].empty?
  end

  def has_tracks?(result,song_idx)
  	result["response"]["songs"][song_idx]["tracks"].empty? 
  end
  
  def has_image?(result)
	result["response"]["images"].empty?
  end

  def extract_id(str)
  	str[str.rindex(":"),str.length]
  end

  # # GET /song_searches/new
  # def new
  #   @song_search = SongSearch.new
  # end

  # # GET /song_searches/1/edit
  # def edit
  # end

  # # POST /song_searches
  # # POST /song_searches.json
  # def create
  #   @song_search = SongSearch.new(song_search_params)

  #   respond_to do |format|
  #     if @song_search.save
  #       format.html { redirect_to @song_search, notice: 'Song search was successfully created.' }
  #       format.json { render :show, status: :created, location: @song_search }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @song_search.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /song_searches/1
  # # PATCH/PUT /song_searches/1.json
  # def update
  #   respond_to do |format|
  #     if @song_search.update(song_search_params)
  #       format.html { redirect_to @song_search, notice: 'Song search was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @song_search }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @song_search.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /song_searches/1
  # # DELETE /song_searches/1.json
  # def destroy
  #   @song_search.destroy
  #   respond_to do |format|
  #     format.html { redirect_to song_searches_url, notice: 'Song search was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_song_search
  #     @song_search = SongSearch.find(params[:id])
  #   end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def song_search_params
  #     params[:song_search]
  #   end
end
