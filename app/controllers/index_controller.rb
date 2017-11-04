get '/' do
  redirect '/users'
end

get '/unauthorized' do
  erb :unauthorized
end
