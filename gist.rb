require 'haml'
require 'htmlentities'
require 'json'
require 'open-uri'
require './ktty'

class Gist < Ktty
  # Redirect empty requests.
  get '/g/' do
    redirect '/', 301
  end

  # Load and process snippet requests.
  get '/g/:snippet' do |id|
    gist = load(id)
    process(gist)

    haml :gist
  end

  # Request the gist from the GitHub API.
  def load(id)
    endpoint = 'https://api.github.com/gists'

    # Attempt API request. If it fails, return a 404.
    # TODO: The request could fail for multiple reasons. We should return something failure-specific.
    begin
      return open("#{endpoint}/#{id}") do |data|
        JSON.parse(data.read)
      end
    rescue OpenURI::HTTPError
      halt 404
    end
  end

  def process(gist)
    @title  = gist['description']
    @assets = []
    @files  = []

    # A gist can contain multiple files so we need to loop through each one.
    gist['files'].each { |file|
      file = file[1]

      # If there's no gist description, try to use a filename as the page title instead.
      # Ignore the default gist filename which begins with "Gistfile".
      if @title.empty? && !file['filename'].start_with?("gistfile")
        @title = file['filename']
      end

      language = get_class file['language']

      @assets.push(language)
      @files.push({
        'content'  => file['content'],
        'language' => language,
        'name'     => file['filename']
      })
    }

    # If we still don't have a page title, use the gist ID as a fallback.
    if @title.empty?
      @title = "gist:#{gist['id']}"
    end

    # Don't load language files multiple times.
    @assets.uniq!
  end
end