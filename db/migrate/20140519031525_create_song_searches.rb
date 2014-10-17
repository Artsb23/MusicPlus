class CreateSongSearches < ActiveRecord::Migration
  def change
    create_table :song_searches do |t|
      t.string :artist_name
      t.string :title
      t.string :spotify_id

      t.timestamps
    end
  end
end
