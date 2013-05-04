require 'sinatra/base'
require 'sinatra/reloader' if development?

require 'haml'
require 'htmlentities'
require 'json'
require 'open-uri'

class Ktty < Sinatra::Base
   set :root  , File.dirname(__FILE__)
   set :static, true

   register Sinatra::Reloader if settings.development?

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
      'Hello, world!'
   end

   get '/g/' do
      redirect '/', 301
   end

   get '/g/:snippet' do |id|
      if settings.development?
         url = '/static'
         api = 'http://mattprice.me/gists'
      else
         url = 'http://static.ktty.co'
         api = 'https://api.github.com/gists'
      end

      # Request the Gist from the GitHub API.
      begin
         gist = open("#{api}/#{id}") do |data|
            JSON.parse(data.read)
         end
      rescue OpenURI::HTTPError => e
         halt 404
      end

      @description  = gist['description']
      @files        = []
      @dependencies = []

      # Gists can contain multiple files so loop through each one.
      gist['files'].each { |file|
         file = file[1]

         content        = HTMLEntities.new.encode file['content']
         language       = get_class file['language']
         @dependencies += get_dependencies language

         @files.push({'language' => language, 'content' => content})
      }

      # Don't load language files multiple times.
      # TODO: We should probably check to see if we support the language.
      @dependencies = @dependencies.uniq

      haml :gist
   end

   not_found do
      '404 Page Not Found'
   end
end