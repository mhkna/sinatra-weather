get '/sessions/new' do
  erb :'sessions/new'
end

post '/sessions' do
  @user = User.authenticate(params[:email], params[:password])
  if @user
    session[:user_id] = @user.id
    redirect "/locations/new"
  else
    status 422
    @errors = ["Login failed"]
    erb :'sessions/new'
  end
end

delete '/sessions' do
  session[:user_id] = nil
  redirect '/'
end
