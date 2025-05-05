module WeatherService
  def self.client
    @client ||= Client.new
  end
end