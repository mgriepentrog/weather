class WeatherController < ApplicationController
  def index
  end

  def forecast
    @location = params[:location]
    if @location
      results = ::Geocoder.search(@location)
      if results.empty?
        flash[:error] = "Could not determine location."
        redirect_to action: :index
      else
        @result = results.first
        @city = @result.city || @result.display_name
        @date = Time.now.strftime("%B %d")
        # @time_zone = TZF.tz_name(@result.latitude, @result.longitude)
        @cache_miss = false
        # Not all locations have a postal code
        @cache_key = @result.postal_code
        @cache_key ||= @result.data["name"] if @result.data.has_key?("name")
        @cache_key ||= @result.display_name
        @forecast = Rails.cache.fetch("forecast/#{@cache_key}", expires_in: 30.minutes) do
          @cache_miss = true
          ::WeatherService.client.forecast(latitude: @result.latitude, longitude: @result.longitude)
        end
        @sunrise = @forecast.daily.sunrise.first
        @sunset = @forecast.daily.sunset.first
        @high = @forecast.daily.temperature_2m_max.first
        @low = @forecast.daily.temperature_2m_min.first
        @is_day = @sunrise < Time.now.utc && Time.now.utc < @sunset
        @wmo_code = @forecast.current.weather_code
        @current_temperature = @forecast.current.temperature_2m
        @temperature_unit = @forecast.current_units.temperature_2m
        @daily_length = @forecast.daily.temperature_2m_max.length
      end
    else
      flash[:error] = "No location specified"
      redirect_to action: :index
    end
  end

  def suggestions
    @suggestions = []
    @suggestions = ::Geocoder.search(params[:q]).map(&:address) if params[:q].present?
    render turbo_stream: helpers.async_combobox_options(@suggestions)
  end
end
