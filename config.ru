# Require config/environment.rb
require ::File.expand_path('../config/environment',  __FILE__)

set :app_file, __FILE__

run Sinatra::Application

environment = Sprockets::Environment.new

environment.append_path "/public/css"
environment.append_path "/public/js"

get "/public/*" do
  env["PATH_INFO"].sub!("/public", "")
  settings.environment.call(env)
end
