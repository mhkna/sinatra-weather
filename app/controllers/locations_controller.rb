get '/locations/new' do
  @location = Location.new
  erb :'locations/new'
end

post '/locations' do
  redirect '/sessions/new?login=no' unless logged_in?
  @location = current_user.locations.new(params[:location])
  if @location.save
    redirect "/locations/#{@location.id}"
  else
    @errors = @location.errors.full_messages
    erb :'locations/new'
  end
end

get '/locations/:id' do
  authenticate!
  @location = Location.find(params[:id])
  erb :'locations/show'
end
