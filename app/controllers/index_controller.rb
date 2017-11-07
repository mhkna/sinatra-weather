get '/' do
  redirect '/sessions/new'
end

get '/unauthorized' do
  erb :unauthorized
end
