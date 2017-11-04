class Location < ActiveRecord::Base
  belongs_to :user

  validates :address, presence: true

  def location_info_get
    uri = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?address=#{self.address}&key=#{ENV["GOOGLE_GEO_TOKEN"]}")
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
    uri = URI.parse("https://api.darksky.net/forecast//#{self.coords}")
    # #{ENV["DARKSKY_TOKEN"]} GET TOKEN WORKING
    api_response = Net::HTTP.get(uri)
    response_collection = JSON.parse(api_response)
  end

  def daily_summary
    weather_resp = weather_get
    weather_resp["daily"]["icon"]
    weather_resp["daily"]["summary"]
  end
end
