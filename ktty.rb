require 'sinatra'
require 'sinatra/reloader' unless ENV['RACK_ENV'] == 'production'

get '/' do
  'Hello, world!'
end