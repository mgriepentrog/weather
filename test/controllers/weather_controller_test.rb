require "test_helper"
require 'webmock/minitest'

class WeatherControllerTest < ActionDispatch::IntegrationTest
  teardown do
    Rails.cache.clear
  end
  test "should get root" do
    get root_path
    assert_response :success
  end

  class Search < self
    test "should redirect if no location" do
      get search_weather_index_path
      assert_redirected_to root_path
    end
  end

  class Suggestions < self
    test "should get suggestions" do
      get suggestions_weather_index_path, as: :turbo_stream
      assert_response :success
    end

    test "return empty array for no results" do
      VCR.use_cassette("geocode_location_does_not_exist") do
        get suggestions_weather_index_path, params: { q: "location_does_not_exist" }, as: :turbo_stream
        assert_response :success
      end
    end

    test "it caches results" do
      VCR.use_cassette("geocode_cache_test") do
        get suggestions_weather_index_path, params: { q: "location_does_not_exist" }, as: :turbo_stream
        get suggestions_weather_index_path, params: { q: "location_does_not_exist" }, as: :turbo_stream
        assert_requested :get, /https:\/\/nominatim\.openstreetmap\.org\/search/,
                         times: 1 # ===> Success
      end
    end

    test "it returns suggestions" do
      VCR.use_cassette("geocode_with_results") do
        get suggestions_weather_index_path, params: { q: "Apple Park Way, Cupertino, Santa Clara County, California, 95014, United States", for_id: "location" }, as: :turbo_stream
        assert_turbo_stream status: :success, action: :update, target: "location-hw-listbox" do
          assert_select "template li", 2 # The given query returns two results
        end
      end
    end
  end
end
