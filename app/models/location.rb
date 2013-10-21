class Location < ActiveRecord::Base

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
    response = JSON.parse(RestClient.get(url))["data"]["current_condition"].first
  end

  def current_conditions_icon_url
    current_conditions["weatherIconUrl"].first["value"]
  end

  def self.popular_locations
    Location.find(:all, :conditions => "request_count > 0", :order => "request_count DESC", :limit => 10)
  end

end
