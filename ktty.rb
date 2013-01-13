require 'sinatra'
require 'sinatra/reloader' if development?

require 'htmlentities'
require 'json'
require 'open-uri'

get '/' do
   host = development? ? "/static" : "http://static.ktty.co"

   # Request the Gist from the GitHub API.
   gist = open('http://cdn.mattprice.me/gists/4520261') do |data|
      JSON.parse(data.read)
   end

   html  = "<!doctype html>"
   html << "<html><head>"
   html << "<title>#{gist['description'].strip}</title>"
   html << "<link href ='#{host}/prism.css' rel='stylesheet' />"
   html << "</head><body>\n"

   # Gists can contain multiple files so loop through each one.
   gist['files'].each { |file|
      file = file[1]

      content  = HTMLEntities.new.encode file['content']
      language = file['language'].downcase

      html << "<pre><code class=\"language-#{language}\">#{content}</code></pre>\n"
   }

   html << "<script src='#{host}/prism.min.js'></script>"
   html << "</body></html>"

   html
end