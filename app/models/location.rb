class Location < ActiveRecord::Base
  belongs_to :user

  validates :address, presence: true

  def formatted_location
    location_info_get["results"][0]["formatted_address"]
  end

  def today_weather
    daily_data = weather_get["daily"]["data"][0]
    output = []
    daily_data.each do |data|
      title = data[0]
      case title
      when "time", "summary", "icon", "temperatureMin", "temperatureMax", "precipProbability", "precipType"
        output << data
      end
    end
    output
  end

  def now_weather
    current_data = weather_get["currently"]
    output = []
    current_data.each do |data|
      title = data[0]
      case title
      when "time", "summary", "icon", "temperature"
        output << data[1]
      end
    end
    output
  end

  def past_weather
    output = []
    past_dates.each do |date|
      uri = URI.parse("https://api.darksky.net/forecast/#{ENV['DARKSKY_TOKEN']}/#{self.coords},#{date}?exclude=currently,minutely,hourly,alerts,flags")
      api_response = Net::HTTP.get(uri)
      response_collection = JSON.parse(api_response)
      output << response_collection["daily"]["data"][0]["icon"]
    end
    output
  end

  def future_weather
    daily_data = weather_get["daily"]["data"]
    output = []
    daily_data[1..3].each do |day|
      day.each do |data|
        title = data[0]
        case title
        when "time", "summary", "icon", "temperatureMax"
          output << data
        end
      end
    end
    output
  end

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
    uri = URI.parse("https://api.darksky.net/forecast/#{ENV['DARKSKY_TOKEN']}/#{self.coords}?exclude=minutely,hourly,alerts,flags")
    api_response = Net::HTTP.get(uri)
    response_collection = JSON.parse(api_response)
  end

  def past_dates
    year = DateTime.now.strftime('%Y').to_i
    remaining_date = DateTime.now.strftime('-%m-%dT00:00:00')
    year_array = (year-5..year-1).to_a.map do |year|
      year.to_s + remaining_date
    end
    year_array
  end
end
