class Location < ActiveRecord::Base
  belongs_to :user

  validates :address, presence: true

  def coord_get
    "https://maps.googleapis.com/maps/api/geocode/json?address=#{self.address}&key=YOUR_API_KEY"
    # uri = URI.parse(URI.encode(endpoint))
    # api_response = Net::HTTP.get(uri)
    # response_collection = JSON.parse(api_response)
    # pp(response_collection)
  end
end
