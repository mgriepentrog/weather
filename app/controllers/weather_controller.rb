class WeatherController < ApplicationController
  def index

  end

  def search
    @location = params[:location]
    if @location
      results = ::Geocoder.search(@location)
      @result = results.first
    end
  end
end
