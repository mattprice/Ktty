require 'haml'
require 'htmlentities'
require 'json'
require 'open-uri'
require 'sinatra/base'

class Ktty < Sinatra::Base
   # Some languages share the same Prism highlighting component,
   # or are found under a different name.
   def get_class(language)
      class_name = {
         'c#'          => 'clike',
         'c++'         => 'cpp',
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

      @description = gist['description']
      @files       = []
      @assets      = []

      # Gists can contain multiple files so loop through each one.
      gist['files'].each { |file|
         file = file[1]

         content   = HTMLEntities.new.encode file['content']
         language  = get_class file['language']

         @files .push({'language' => language, 'content' => content})
         @assets.push(language)
      }

      # Don't load language files multiple times.

      @assets = @assets.uniq

      haml :gist
   end

   not_found do
      '404 Page Not Found'
   end
end