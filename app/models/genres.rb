require 'rubygems'
require 'open-uri'
require 'json'

TOP_HOT_URL = "http://developer.echonest.com/api/v4/artist/top_hottt?api_key=C3KAM8MI2NSR1PCX7&format=json&start=0&bucket=terms&results="
LIST_GENRE_URL = "http://developer.echonest.com/api/v4/genre/list?api_key=DMXIXHBUKTIQUHV9F&format=json&results=1500"
class Genres


	def get_tag_cloud_for_top_artists(num=1000)
		url = TOP_HOT_URL + num.to_s
    	result = JSON.parse(open(url).read)
    	genre_count = Hash.new(0)
    	if is_success?(result) && !result["response"]["artists"].empty? then
			artists_elem = result["response"]["artists"]
			artists_elem.each do |anArtist|
				if !anArtist["terms"].empty?
					anArtist["terms"].each do |term|
						genre_count[term["name"]] += 1 
					end
				end
			end
    	end
    	tag_cloud = []
    	genre_count.each do |key,value|
    		tag_cloud.push({"text" => key, "weight" => value, "link" => "http://localhost:3000/song_searches/genre?name=" + URI::encode(key.to_s)})
    	end
    	tag_cloud
	end 

	def get_all_genres
    	result = JSON.parse(open(LIST_GENRE_URL).read)
    	genre_cloud = []
    	if is_success?(result) && !result["response"]["genres"].empty? then
    		genres_elem = result["response"]["genres"]
    		(0...350).each do |loop_cnt|
    			idx = rand(1000)
    			genre_name = genres_elem[idx]["name"]
    			genre_cloud.push({"text" => genre_name,"weight" => rand(),"link" => "http://localhost:3000/song_searches/genre?name=" + genre_name.to_s})
    		end
    	end
    	genre_cloud
	end

	def is_success?(result)
		result["response"]["status"]["message"] == "Success"
  	end
end