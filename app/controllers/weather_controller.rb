class WeatherController < ApplicationController
  def index

  end

  def search
    @location = params[:location]
    if @location
      results = ::Geocoder.search(@location)
      @result = results.first
      weather_service = ::WeatherService.new(@result.latitude, @result.longitude)
      @response = weather_service.forecast
    else
      redirect_to action: :index
    end
  end

  def suggestions
    @suggestions = []
    @suggestions = ::Geocoder.search(params[:q]).map(&:address) if params[:q].present?
    render turbo_stream: helpers.async_combobox_options(@suggestions)
  end
end
