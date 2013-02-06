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
    url = "http://free.worldweatheronline.com/feed/weather.ashx?q=" + zip + "&format=json&key=55d99285d6001415122608"
    response = JSON.parse(RestClient.get(url))["data"]["current_condition"].first
  end

  def self.popular_locations
    Location.find(:all, :conditions => "request_count > 0", :order => "request_count DESC", :limit => 10)
  end

end
