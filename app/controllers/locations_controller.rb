post '/locations' do
  @location = Location.new(params[:location])
  if @location.save
    redirect "/locations/#{@location.id}"
  else
    @errors = @location.errors.full_messages
    erb :'users/show'
  end
end

get '/locations/:id' do
  @location = Location.find(params[:id])
  erb :'locations/show'
end
