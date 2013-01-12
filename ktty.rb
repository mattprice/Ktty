require 'htmlentities'
require 'json'
require 'open-uri'
require 'sinatra'
require 'sinatra/reloader' unless ENV['RACK_ENV'] == 'production'

get '/' do
   html = ""

   # https://api.github.com/gists/5ba8b745963d9f89683b
   gist = open('http://cdn.mattprice.me/gists/5ba8b745963d9f89683b') do |data|
      JSON.parse(data.read)
   end

   gist['files'].each { |file|
      content  = HTMLEntities.new.encode file[1]['content']
      language = file[1]['language']

      html << "RACK_ENV: #{ENV['RACK_ENV']} <br>\n"
      html << "Language: #{language} <br>\n"
      html << "<pre><code class=\"language-#{language}\">#{content}</code></pre>"
   }

   html
end