get '/' do
  redirect '/users/new'
end

get '/unauthorized' do
  erb :unauthorized
end
