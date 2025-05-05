require "net/http"
module WeatherService
  class Client
    BASE_URI = "https://api.open-meteo.com/v1"

    def forecast(latitude:, longitude:)
      params = {
        latitude: latitude,
        longitude: longitude,
        current: "temperature_2m,weather_code",
        daily: "temperature_2m_max,temperature_2m_min,precipitation_probability_max,weather_code,sunrise,sunset",
        wind_speed_unit: "mph",
        temperature_unit: "fahrenheit",
        precipitation_unit: "inch"
      }
      # Net::HTTP.get(url, path)
      get "/forecast", query: params
    end

    private

    def get(path, query: {})
      uri = URI("#{BASE_URI}#{path}")
      uri.query = Rack::Utils.build_query(query)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.instance_of?(URI::HTTPS)

      request = Net::HTTP::Get.new(uri.request_uri, {
        "Accept" => "application/json"
      })
      response = http.request(request)
      case response.code.to_i
      when 200
        json = JSON.parse(response.body, symbolize_names: true) if response.body.present?
        WeatherService::ForecastResponse.from_hash(json)
      else
        WeatherService::ForecastResponse.from_hash({})
      end
    end
  end
end
