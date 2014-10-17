require 'rubygems'
require 'open-uri'
require 'json'


SONG_SEARCH_URL = "http://developer.echonest.com/api/v4/song/search?api_key=C3KAM8MI2NSR1PCX7&format=json&results=95&bucket=id:spotify-WW&bucket=audio_summary&bucket=song_type&sort=song_hotttnesss-desc&bucket=tracks&title="
SONG_SEARCH_URL_limit = "http://developer.echonest.com/api/v4/song/search?api_key=DMXIXHBUKTIQUHV9F&format=json&results=3&bucket=id:spotify-WW&bucket=audio_summary&bucket=song_type&bucket=tracks&title="
URL = "http://developer.echonest.com/api/v4/song/search?api_key=DMXIXHBUKTIQUHV9F&format=json&results=5&bucket=id&bucket=audio_summary&bucket=tracks&title="
ARTIST_URL = "http://developer.echonest.com/api/v4/artist/images?api_key=DMXIXHBUKTIQUHV9F&format=json&results=1&start=0&license=unknown&name="
ARTIST_SONGS_URL = "http://developer.echonest.com/api/v4/artist/songs?api_key=C3KAM8MI2NSR1PCX7&format=json&start=0&results=55&name="
ARTIST_BLOG_URL = "http://developer.echonest.com/api/v4/artist/blogs?api_key=DMXIXHBUKTIQUHV9F&format=json&results=3&start=0&name="
ARTIST_BIO_URL = "http://developer.echonest.com/api/v4/artist/biographies?api_key=DMXIXHBUKTIQUHV9F&format=json&results=1&start=0&license=cc-by-sa&name="
SONG_SEARCH_URL_ARTIST = "http://developer.echonest.com/api/v4/song/search?api_key=C3KAM8MI2NSR1PCX7&format=json&results=1&bucket=id:spotify-WW&bucket=audio_summary&bucket=song_type&bucket=tracks&title="
ALBUM_IMG_URL = "http://developer.echonest.com/api/v4/song/search?api_key=DMXIXHBUKTIQUHV9F&format=json&results=25&bucket=id:7digital-US&bucket=audio_summary&bucket=song_type&bucket=tracks&title="
PLAYLIST_URL = "http://developer.echonest.com/api/v4/playlist/static?api_key=C3KAM8MI2NSR1PCX7&format=json&results=100&type=artist&bucket=tracks&bucket=id:spotify-WW&artist="
PLAYLIST_GENRE_URL = "http://developer.echonest.com/api/v4/playlist/static?api_key=C3KAM8MI2NSR1PCX7&format=json&results=30&type=genre-radio&bucket=tracks&bucket=id:spotify-WW&genre="

$type = ""


class SongSearch

  def initialize()
    
  end

  def artist_name
    @artist_name
  end
  
  def artist_bio
    @artist_bio
  end
  
  def artist_img
    @artist_img
  end

  def title
    @title
  end
  
  def song_type
	@song_type
  end

  def spotify_id
  	@spotify_id
  end
	
  def song_name
	@song_name
  end
  
  def songs
	@songs
  end

  def get_song_search_details(name, num=0)
	url = SONG_SEARCH_URL + URI::encode(name)
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
				
						
				for song in song_elem[@song_idx]["tracks"] do
					
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
							@spotify_id << extract_id(song["foreign_id"])
						#end
					end
					
					
				end
			end
			@song_idx += 1
			
		end
    	@spotify_id = @spotify_id.zip(@title, @artist_name, @song_type, @artist_img);

		
   	end
	
  end
  
  def search_artist(artist_name)
	 
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
  end
  
  def songs_artist(artist_name, song_name)
	i = 0
	@spotify_id = []
			@title = []
			@artist_name = []
			@song_type = []
			@artist_img = []
	for name in song_name
		url = SONG_SEARCH_URL + URI::encode(name) + "&artist=" + URI::encode(artist_name)
		albm_url = ALBUM_IMG_URL + URI::encode(name)
		begin
			result = JSON.parse(open(url).read)
		rescue
			next
		end
		if is_success?(result) then
			# check if a track is found
			#valid song with track
			song_elem = result["response"]["songs"]
			
			
			@song_idx = 0
			while(@song_idx < result["response"]["songs"].length )
				
				if has_tracks?(result,@song_idx) then
					check = true
					@name_artist = song_elem[@song_idx]["artist_name"]
					
					#puts @img_result
					
					unless @title.include? song_elem[@song_idx]["title"]
							check = false
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
					check = true
					
					#for song in song_elem[@song_idx]["tracks"] do
						
						
						unless @title.include? song_elem[@song_idx]["title"]
							check = false
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
						
						
					#end
				end
				@song_idx += 1
				
			end
			
			
		end
	end
	@spotify_id = @spotify_id.zip(@title, @artist_name, @song_type, @artist_img)
			puts @spotify_id
			puts i+=1
  end
  
 
  
  def playlist(name)
	@song_name = name
	url = PLAYLIST_URL + URI::encode(name)
    result = JSON.parse(open(url).read)
	if is_success?(result) then
    	# check if a track is found
    	#valid song with track
    	song_elem = result["response"]["songs"]
		@songs = ""
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
				
				#puts @img_result
				for item in @title
					if(song_elem[@song_idx]["title"] == item)
						check = true
					end
				end
				
				unless check == true
					unless (!(song_elem[@song_idx].has_key? ["artist_foreign_ids"]))
						@title << song_elem[@song_idx]["title"]
						@artist_name << song_elem[@song_idx]["artist_name"]
						@song_type << song_elem[@song_idx]["song_type"]
						@spotify_id << extract_id(song_elem[@song_idx]["artist_foreign_ids"][0]["foreign_id"])
					end
				end
				
			end
			
			unless has_tracks?(result,@song_idx)  
				check = false	
						
				/for song in song_elem[@song_idx]["tracks"] do/
					for item in @title
						if(song_elem[@song_idx]["title"] == item)
							check = true
						end
					end
					
					unless check == true
					#unless (!(song_elem[@song_idx].has_key? ["artist_foreign_ids"]))
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
    	for item in @spotify_id
			@songs = @songs + item.tr(':','') + ","
		end
		
		
   	end
end

def genre_playlist(name)
	@song_name = name
	begin
	url = PLAYLIST_GENRE_URL + URI::encode(name)
    result = JSON.parse(open(url).read)
	rescue
	else
	if is_success?(result) then
    	# check if a track is found
    	#valid song with track
    	song_elem = result["response"]["songs"]
		#@img_result = JSON.parse(open(ARTIST_URL + song_elem["artist_id"]).read)
		#@artist_songs = JSON.parse(open(ARTIST_SONGS_URL + song_elem["artist_id"]).read)
		#@artist_img = @img_result["response"]["images"][0]["url"]
		
		@songs = ""
		@spotify_id = []
		@title = []
		@artist_name = []
		@song_type = []
		@artist_img = []
		@song_idx = 0
		while(@song_idx < result["response"]["songs"].length )
		puts result["response"]["songs"]
			
			if has_tracks?(result,@song_idx) then
				
				check = false
				@name_artist = song_elem[@song_idx]["artist_name"]
				
				#puts @img_result
				
				for item in @title
					if(song_elem[@song_idx]["title"] == item)
						check = true
					end
				end
				
				unless check == true
					unless (!(song_elem[@song_idx].has_key? ["artist_foreign_ids"]))
						@title << song_elem[@song_idx]["title"]
						@artist_name << song_elem[@song_idx]["artist_name"]
						@song_type << song_elem[@song_idx]["song_type"]
						@spotify_id << extract_id(song_elem[@song_idx]["artist_foreign_ids"][0]["foreign_id"])
					end
				end
				
			end
			
			unless has_tracks?(result,@song_idx)  
				check = false	
						
				/for song in song_elem[@song_idx]["tracks"] do/
					
					for item in @title
					if(song_elem[@song_idx]["title"] == item)
						check = true
					end
					end
					unless check == true
					#unless (!(song_elem[@song_idx].has_key? ["artist_foreign_ids"]))
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
    	#@spotify_id = @spotify_id.zip(@title, @artist_name, @song_type, @artist_img);
		for item in @spotify_id
			@songs = @songs + item.tr(':','') + ","
		end
		puts @songs
		
	end	
   	end
end


  
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

end

