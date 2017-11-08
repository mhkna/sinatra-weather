class Location < ActiveRecord::Base
  belongs_to :user

  validates :address, presence: true

  def formatted_address
    location_info_get["results"][0]["formatted_address"]
  end

  def now_weather
    current_data = weather_get["currently"]
    "#{current_data["summary"].capitalize} and #{current_data["temperature"].round} degrees"
  end

  def today_summary
    daily_data["summary"]
  end

  def today_icon
    daily_data["icon"]
  end

  def today_details
    data = daily_data
    max = data["temperatureMax"].round
    min = data["temperatureMin"].round
    percent = data["precipProbability"] * 100
    type = data["precipType"]
    if type
      "High of #{max} degrees with a #{percent.round}% chance of #{type}"
    else
      "There is a high of #{max} and a low of #{min} degrees"
    end
  end

  def future_weather
    daily_data = weather_get["daily"]["data"]
    output = []
    daily_data[1..3].each do |day|
      day.each do |data|
        title = data[0]
        case title
        when "time", "summary", "temperatureMax"
          output << data[1]
        end
      end
    end
    output.each_slice(3).to_a
  end

  def past_low_temp
    past_temp("temperatureLow")
  end

  def past_high_temp
    past_temp("temperatureHigh")
  end

  private

  def location_info_get
    uri = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{ENV['GOOGLE_GEO_TOKEN']}")
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
    uri = URI.parse("https://api.darksky.net/forecast/#{ENV['DARKSKY_TOKEN']}/#{coords}?exclude=minutely,hourly,alerts,flags")
    api_response = Net::HTTP.get(uri)
    response_collection = JSON.parse(api_response)
  end

  def daily_data
    weather_get["daily"]["data"][0]
  end

  def past_dates
    year = DateTime.now.strftime('%Y').to_i
    remaining_date = DateTime.now.strftime('-%m-%dT00:00:00')
    past_dates_array = (year-5..year-1).to_a.map do |year|
      year.to_s + remaining_date
    end
    past_dates_array
  end

  def past_temp(category)
    output = {}
    past_dates.each do |date|
      uri = URI.parse("https://api.darksky.net/forecast/#{ENV['DARKSKY_TOKEN']}/#{coords},#{date}?exclude=currently,minutely,hourly,alerts,flags")
      api_response = Net::HTTP.get(uri)
      response_collection = JSON.parse(api_response)
      output[date] = response_collection["daily"]["data"][0][category]
    end
    output
  end
end
