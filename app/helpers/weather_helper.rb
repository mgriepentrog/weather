module WeatherHelper
  def render_wmo_code(wmo_code, is_day, size: "fa-5x")
    # see https://www.nodc.noaa.gov/archive/arc0021/0002199/1.1/data/0-data/HTML/WMO-CODE/WMO4677.HTM
    puts "wmo_code: #{wmo_code}"
    icon_class = case wmo_code
    when 4
                   "fa-smog"
    when 5..9
                   "fa-wind"
    when 13
                   "fa-bolt-lightning"
    when 17, 18
                   "fa-bolt"
    when 19
                   "fa-tornado"
    when 30..39
                   "fa-wind"
    when 50..65
                   "fa-cloud-showers-heavy"
    when 70..78
                   "fa-snowflake"
    when 80..82
                   "fa-cloud-showers-heavy"
    when 85..86
                   "fa-snowflake"
    when 91..99
                   "fa-cloud-bolt"
    else
                   is_day ? "fa-sun" : "fa-moon"
    end
    content_tag(:i, "",
                class: "fa-solid #{size} #{icon_class}",
                style: "align-content: center")
  end
end
