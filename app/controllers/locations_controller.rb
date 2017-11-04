post '/locations' do
  @location = Location.new(params[:location])
  if @location.save
    redirect "/users/#{current_user.id}"
  else
    @errors = @location.errors.full_messages
    erb :'users/show'
  end
end
