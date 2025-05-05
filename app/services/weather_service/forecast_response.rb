module WeatherService
  class ForecastResponse < Data.define(:latitude, :longitude, :generationtime_ms, :utc_offset_seconds, :timezone, :timezone_abbreviation,
                                       :elevation, :hourly_units, :hourly, :current_units, :current, :daily_units, :daily)
    def self.from_hash(hash)
      allowed_keys = members

      filtered_hash = hash.slice(*allowed_keys)

      defaults = allowed_keys.index_with { |_| nil }
      response_hash = defaults.merge(filtered_hash)

      if hash.has_key?(:current)
        current_hash = hash[:current]
        response_hash[:current] = Current.new(**current_hash)
      end
      if hash.has_key?(:current_units)
        current_units_hash = hash[:current_units]
        response_hash[:current_units] = CurrentUnits.new(**current_units_hash)
      end
      if hash.has_key?(:hourly)
        hourly_hash = hash[:hourly]
        response_hash[:hourly] = Hourly.new(**hourly_hash)
      end
      if hash.has_key?(:hourly_units)
        hourly_units_hash = hash[:hourly_units]
        response_hash[:hourly_units] = HourlyUnits.new(**hourly_units_hash)
      end
      if hash.has_key?(:daily)
        daily_hash = hash[:daily]
        daily_hash[:sunrise] = daily_hash[:sunrise].map { |t| Time.parse(t).utc }
        daily_hash[:sunset] = daily_hash[:sunset].map { |t| Time.parse(t).utc }
        response_hash[:daily] = Daily.new(**daily_hash)
      end
      if hash.has_key?(:daily_units)
        daily_units_hash = hash[:daily_units]
        response_hash[:daily_units] = DailyUnits.new(**daily_units_hash)
      end
      new(**response_hash)
    end

    class CurrentUnits < Data.define(:time, :interval, :temperature_2m, :weather_code)

    end

    class Current < Data.define(:time, :interval, :temperature_2m, :weather_code)

    end

    class HourlyUnits < Data.define(:time, :temperature_2m, :relative_humidity_2m, :wind_speed_10m)

    end

    class Hourly < Data.define(:time, :temperature_2m, :relative_humidity_2m, :wind_speed_10m)

    end

    class DailyUnits < Data.define(:time, :temperature_2m_max, :temperature_2m_min, :precipitation_probability_max, :weather_code, :sunrise, :sunset)
    end

    class Daily < Data.define(:time, :temperature_2m_max, :temperature_2m_min, :precipitation_probability_max, :weather_code, :sunrise, :sunset)
    end
  end
end