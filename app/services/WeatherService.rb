class WeatherService
  attr_accessor :latitude, :longitude

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def forecast
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{@latitude}&longitude=#{@longitude}&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    data
  end
end