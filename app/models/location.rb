class Location < ActiveRecord::Base

  RADAR_LOCATIONS = {
    'lit' => [34.7294, -92.2244],
    'prc' => [34.6544, -112.4197],
    'bfl' => [35.4339, -119.0578],
    'den' => [39.8617, -104.6731],
    'hfd' => [41.7367, -72.6494],
    'eyw' => [24.5561, -81.7594],
    'pie' => [27.9100, -82.6875],
    'csg' => [32.5164, -84.9389],
    'dsm' => [41.5339, -93.6631],
    'myl' => [44.8886, -116.1017],
    'spi' => [39.8442, -89.6781],
    'sln' => [38.7908, -97.6522],
    'bwg' => [36.9644, -86.4197],
    'msy' => [29.9933, -90.2581],
    'cad' => [44.2753, -85.4189],
    'stc' => [45.5467, -94.0600],
    'jef' => [38.5911, -92.1561],
    'tvr' => [32.3517, -91.0278],
    'lwt' => [47.0492, -109.4667],
    'clt' => [35.2139, -80.9431],
    'bis' => [46.7728, -100.7458],
    'lbf' => [41.1261, -100.6836],
    'bml' => [44.5753, -71.1758],
    'row' => [33.3017, -104.5306],
    'rno' => [39.4992, -119.7681],
    'bgm' => [42.2086, -75.9797],
    'day' => [39.9025, -84.2194],
    'law' => [34.5678, -98.4167],
    'rdm' => [44.2542, -121.1500],
    'pir' => [44.3828, -100.2861],
    'bro' => [25.9068, -97.4258],
    'sat' => [29.5336, -98.4697],
    'pvu' => [40.2192, -111.7233],
    'fcx' => [37.0242, -80.2742],
    'shd' => [38.2639, -78.8964],
    'tiw' => [47.2681, -122.5781],
    'riw' => [43.0642, -108.4597]
  }

  attr_accessible :address, :latitude, :longitude

  # https://github.com/alexreisner/geocoder/tree/rails2
  # script/plugin install git://github.com/alexreisner/geocoder.git -r rails2
  geocoded_by :address

# JSON.parse(RestClient.get("http://free.worldweatheronline.com/feed/weather.ashx?q=49720&format=json&key=55d99285d6001415122608"))

  def to_s
    "#{city}, #{state}"
  end

  def self.zip_format?(str)
    ('A'..'Z').each do |ltr|
      str.gsub!(ltr, '')
      str.gsub!(ltr.downcase, '')
    end
    str.length == 5
  end

  def current_conditions
    # http://developer.worldweatheronline.com/documentation
    # url = "http://free.worldweatheronline.com/feed/weather.ashx?q=" + zip + "&format=json&key=55d99285d6001415122608"
    url = "http://api.worldweatheronline.com/free/v1/weather.ashx?q=" + zip + "&format=json&key=z8qme23navrzw7dq9hp7mudf"

    response_string = DbCacheItem.get("current_conditions_location_id_#{id}", :valid_for => 30.minutes) do
      RestClient.get(url)
    end
    response = JSON.parse(response_string)["data"]["current_condition"].first
    parse_forecast_json(response)
  end

  def weather_forecast(n_days)
    url = "http://api.worldweatheronline.com/free/v1/weather.ashx?q=#{zip}&format=json&num_of_days=#{n_days}&key=z8qme23navrzw7dq9hp7mudf"
    valid_for = if DateTime.tomorrow.beginning_of_day - DateTime.now < 3600
                  DateTime.tomorrow.beginning_of_day - DateTime.now
                else
                  3600
                end
    response_string = DbCacheItem.get("weather_forecast_#{n_days}_for_location_id#{id}", :valid_for => valid_for) do
      RestClient.get(url)
    end
    response = JSON.parse(response_string)["data"]["weather"]
    arr = []
    response.each do |r|
      arr << parse_forecast_json(r)
    end
    # parse_forecast_json(response)
  end

  def nearest_radar_location
    arr = []
    Location::RADAR_LOCATIONS.each do |key, value|
      arr << [key, Geocoder.distance_between(latitude, longitude, value.first, value.last)]
    end
    arr.sort_by(&:last).first.first
  end

  def radar_image_url
    "http://images.intellicast.com/WxImages/Radar/#{nearest_radar_location}.gif"
  end

  def self.popular_locations
    Location.find(:all, :conditions => "request_count > 0", :order => "request_count DESC", :limit => 100)
  end

  def parse_forecast_json(json_response)
    response = json_response
    response["weatherDesc"] = (response["weatherDesc"].first["value"] rescue "")
    response["weatherIconUrl"] = (response["weatherIconUrl"].first["value"] rescue "")
    response
  end

end
