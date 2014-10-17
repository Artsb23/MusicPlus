json.array!(@song_searches) do |song_search|
  json.extract! song_search, :id, :artist_name, :title, :spotify_id
  json.url song_search_url(song_search, format: :json)
end
