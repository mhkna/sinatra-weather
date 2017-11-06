get '/' do
  redirect '/locations/new'
end

get '/unauthorized' do
  erb :unauthorized
end
