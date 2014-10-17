require 'test_helper'

class SongSearchesControllerTest < ActionController::TestCase
  setup do
    @song_search = song_searches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:song_searches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create song_search" do
    assert_difference('SongSearch.count') do
      post :create, song_search: { artist_name: @song_search.artist_name, spotify_id: @song_search.spotify_id, title: @song_search.title }
    end

    assert_redirected_to song_search_path(assigns(:song_search))
  end

  test "should show song_search" do
    get :show, id: @song_search
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @song_search
    assert_response :success
  end

  test "should update song_search" do
    patch :update, id: @song_search, song_search: { artist_name: @song_search.artist_name, spotify_id: @song_search.spotify_id, title: @song_search.title }
    assert_redirected_to song_search_path(assigns(:song_search))
  end

  test "should destroy song_search" do
    assert_difference('SongSearch.count', -1) do
      delete :destroy, id: @song_search
    end

    assert_redirected_to song_searches_path
  end
end
