class GenresController < ApplicationController

	def show
		@genres = Genres.new()
		begin
		render :json => @genres.get_tag_cloud_for_top_artists(10).to_json
		rescue
		end
		#render :json => @genres.get_all_genres.to_json
		
	end


end