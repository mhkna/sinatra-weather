get '/locations/new' do
  @location = Location.new
  erb :'locations/new'
end

post '/locations' do
  @location = Location.new(params[:location])
  if @location.save
    redirect "/locations/#{@location.id}"
  else
    @errors = @location.errors.full_messages
    erb :'locations/show'
  end
end

get '/locations/:id' do
  @location = Location.find(params[:id])
  erb :'locations/show'
end
