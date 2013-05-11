require 'haml'
require 'htmlentities'
require 'json'
require 'open-uri'
require './ktty'

class Gist < Ktty
  # Redirect blank requests.
  get '/g/' do
    redirect '/', 301
  end

  # Load snippet requests.
  get '/g/:snippet' do |id|
    # Set the development Gist API endpoint.
    api = settings.development? ? 'http://mattprice.me' : 'https://api.github.com'

    # Request the Gist from the GitHub API.
    begin
      gist = open("#{api}/gists/#{id}") do |data|
        JSON.parse(data.read)
      end
    rescue OpenURI::HTTPError
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

      @files .push({'language' => language, 'content' => content, 'name' => file['filename']})
      @assets.push(language)
    }

    # Don't load language files multiple times.
    @assets = @assets.uniq

    haml :gist
  end
end