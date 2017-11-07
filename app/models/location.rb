class Location < ActiveRecord::Base
  belongs_to :user

  validates :address, presence: true

  def hi
    {"high" => [1, 2, 3, 4, 5], "low" => [4, 5, 6, 7, 8]}
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

  def formatted_address
    location_info_get["results"][0]["formatted_address"]
  end

  def weather_get
    uri = URI.parse("https://api.darksky.net/forecast/#{ENV['DARKSKY_TOKEN']}/#{self.coords}?exclude=minutely,hourly,alerts,flags")
    api_response = Net::HTTP.get(uri)
    response_collection = JSON.parse(api_response)
  end

  def now_weather
    current_data = weather_get["currently"]
    "#{current_data["summary"].capitalize} and #{current_data["temperature"].round} degrees."
  end

  def daily_data
    weather_get["daily"]["data"][0]
  end

  def today_summary
    daily_data["summary"]
  end

  def today_icon
    daily_data["icon"]
  end

  def today_high_low
    min = daily_data["temperatureMin"]
    max = daily_data["temperatureMax"]
    "High: #{max}, Low: #{min}"
  end

  def today_precip
    percent = daily_data["precipProbability"]
    type = daily_data["precipType"]
    "#{percent} chance of #{type}"
  end

  # def today_details
  #   daily_data = weather_get["daily"]["data"][0]
  #   output = []
  #   daily_data.each do |data|
  #     title = data[0]
  #     case title
  #     when "temperatureMin", "temperatureMax", "precipProbability", "precipType"
  #       output << data
  #     end
  #   end
  #   output
  # end

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

  def past_dates
    year = DateTime.now.strftime('%Y').to_i
    remaining_date = DateTime.now.strftime('-%m-%dT00:00:00')
    past_dates_array = (year-5..year-1).to_a.map do |year|
      year.to_s + remaining_date
    end
    past_dates_array
  end

  def past_weather
    output = []
    past_dates.each do |date|
      uri = URI.parse("https://api.darksky.net/forecast/#{ENV['DARKSKY_TOKEN']}/#{self.coords},#{date}?exclude=currently,minutely,hourly,alerts,flags")
      api_response = Net::HTTP.get(uri)
      response_collection = JSON.parse(api_response)
      output.push(response_collection["daily"]["data"][0]["temperatureHigh"], response_collection["daily"]["data"][0]["temperatureLow"])
    end
    output
  end
end
