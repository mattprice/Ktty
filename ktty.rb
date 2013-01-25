require 'sinatra'
require 'sinatra/reloader' if development?

require 'htmlentities'
require 'json'
require 'open-uri'

# Some languages share the same Prism highlighting component, at least for now.
def get_class(language)
   class_name = {
      'c#'          => 'clike',
      'c++'         => 'clike',
      'd'           => 'clike',
      'go'          => 'clike',
      'html'        => 'markup',
      'json'        => 'javascript',
      'objective-c' => 'clike',
      'perl'        => 'clike',
      'php'         => 'clike',
      'rust'        => 'clike',
      'vala'        => 'clike',
   }

   language = language.downcase
   class_name[language] || language
end

# Some languages may extend a base language (e.g., JavaScript extends "clike").
# Some languages may contain others (e.g., HTML can contain JavaScript or CSS).
def get_dependencies(language)
   extends = {
      'javascript' => ['clike'],
      'java'       => ['clike'],
   }

   contains = {
      'markup' => ['css', 'javascript'],
   }

   r  = extends[language] || []
   r += [language]
   r += contains[language] || []
end

get '/' do
   url = development? ? "/static" : "http://static.ktty.co"

   # Request the Gist from the GitHub API.
   gist = open('http://cdn.mattprice.me/gists/4520261') do |data|
      JSON.parse(data.read)
   end

   html  = "<!doctype html>"
   html << "<html><head>"
   html << "<title>#{gist['description'].strip}</title>"
   html << "<link href ='#{url}/ktty.css' rel='stylesheet' />"
   html << "<link href='http://fonts.googleapis.com/css?family=Source+Code+Pro' rel='stylesheet' type='text/css'>"
   html << "</head><body>\n"

   # Gists can contain multiple files so loop through each one.
   dependencies = []
   gist['files'].each { |file|
      file = file[1]

      content       = HTMLEntities.new.encode file['content']
      language      = get_class file['language']
      dependencies += get_dependencies language

      html << "<pre><code class=\"language-#{language}\">#{content}</code></pre>\n"
   }

   # Include specific language files.
   # TODO: This should probably check to see if we support the language.
   html << "<script src='#{url}/prism.min.js'></script>"
   dependencies.uniq.each { |language|
      html << "<script src='#{url}/#{language}.min.js'></script>"
   }

   html << "</body></html>"

   html
end