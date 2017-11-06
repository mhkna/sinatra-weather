class Location < ActiveRecord::Base
  belongs_to :user

  validates :address, presence: true

  def location_info_get
    uri = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?address=#{self.address}&key=#{ENV['GOOGLE_GEO_TOKEN']}")
    api_response = Net::HTTP.get(uri)
    response_collection = JSON.parse(api_response)
  end

  def coords
    coords_resp = location_info_get["results"][0]["geometry"]["location"]
    lat = coords_resp["lat"]
    lng = coords_resp["lng"]
    "#{lat},#{lng}"
  end

  def weather_get
    uri = URI.parse("https://api.darksky.net/forecast/#{ENV['DARKSKY_TOKEN']}/#{self.coords}")
    api_response = Net::HTTP.get(uri)
    response_collection = JSON.parse(api_response)
  end

  def daily_weather
    p daily_data = weather_get["daily"]["data"][0]
    output = []
    daily_data.each do |data|
      title = data[0]
      case title
      when "summary", "icon", "sunriseTime", "sunsetTime", "temperatureMin", "temperatureMax"
        output << data
      end
    end
    output
  end

  def current_weather
    current_data = weather_get["currently"]
    output = []
    current_data.each do |data|
      title = data[0]
      case title
      when "summary", "icon", "temperature"
        output << data
      end
    end
    output
  end
end
